report 50016 "Update Dimensions By Excel"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Dimensions by excel';
    Permissions = tabledata "G/L Entry" = RM;



    trigger OnPreReport()
    var
        X: Integer;
    begin
        ReadExcelData();

        GetLastRow;
        FOR X := 2 TO TotalRows DO
            InsertData(X);
        ExcelBufferTe.DELETEALL;
        Message(ImportMsg);

    end;

    procedure ReadExcelData()
    var
        FileManagement: Codeunit "File Management";
        FromFile: Text[100];
        IsStream: InStream;
        Uploading: Label 'Please Choose The Excel File';
        NoFileMsg: Label 'No Excel File Found';
    begin
        UploadIntoStream(Uploading, '', '', FromFile, IsStream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := ExcelBufferTe.SelectSheetsNameStream(IsStream);
        end else
            Error(NoFileMsg);
        ExcelBufferTe.Reset();
        ExcelBufferTe.DeleteAll();
        ExcelBufferTe.OpenBookStream(IsStream, SheetName);
        ExcelBufferTe.ReadSheet();
    end;

    procedure GetLastRow();
    begin
        ExcelBufferTe.SetRange("Row No.", 1);
        TotalColumns := ExcelBufferTe.Count;
        ExcelBufferTe.RESET;
        IF ExcelBufferTe.FINDLAST THEN
            TotalRows := ExcelBufferTe."Row No.";
    end;

    procedure InsertData(RowNo: Integer)
    var
        ColNo: Integer;
        PostingDatevar: Date;
        PrevDocNo: Code[20];
        EntryNo: Integer;
    begin
        Clear(DimensionSetID);
        Evaluate(PostingDatevar, GetValueAtCell(RowNo, 2));
        if (Evaluate(EntryNo, GetValueAtCell(RowNo, 4))) then;

        GLEntryGrec.Reset();
        GLEntryGrec.SetRange("Document No.", GetValueAtCell(RowNo, 1));
        GLEntryGrec.SetRange("Posting Date", PostingDatevar);
        GLEntryGrec.SetRange("G/L Account No.", GetValueAtCell(RowNo, 3));
        if EntryNo <> 0 then
            GLEntryGrec.SetRange("Entry No.", EntryNo);
        if GLEntryGrec.FindSet() then
            repeat
                Clear(DimensionSetID);
                InsertDimensions(GetValueAtCell(RowNo, 5), GetValueAtCell(RowNo, 6), DimensionSetID);
                GLEntryGrec.Validate("Global Dimension 1 Code", GetValueAtCell(RowNo, 5));
                GLEntryGrec.Validate("Global Dimension 2 Code", GetValueAtCell(RowNo, 6));
                GLEntryGrec."Dimension Set ID" := DimensionSetID;
                GLEntryGrec.Modify(true);
            until GLEntryGrec.Next() = 0;

    end;

    procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBufferTe.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        ExcelBufferTe.Reset();
        ExcelBufferTe.DeleteAll();
        ExcelBufferTe.OpenBookStream(IStream, SheetName);
        ExcelBufferTe.ReadSheet();

    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        ExcelBufferTe.Reset();
        If ExcelBufferTe.Get(RowNo, ColNo) then
            exit(ExcelBufferTe."Cell Value as Text")
        else
            exit('');
    end;

    procedure InsertDimensions(DimensionCodePar: code[20]; DimensionCodePar2: code[20]; var DimSetID: Integer)
    Var
        DimesionValues: Record "Dimension Value";
        Dimensions: Record Dimension;
        DimensionSetEntry: Record "Dimension Set Entry";
        ErrTxt: Label 'Dimension Code "%1" is not found in specified Row No. - %2 and Column - %3';
        ErrTxt1: Label 'Dimension Value "%1" against a Dimension Code "%4" is not found in specified Row No. - %2 and Column - %3';
        RowValue: Text;
        GenLedgSetup: Record "General Ledger Setup";
    begin
        GenLedgSetup.Get();
        if Dimensions.Get(GenLedgSetup."Global Dimension 1 Code") then begin
            if DimesionValues.Get(Dimensions.Code, DimensionCodePar) then begin
                InitDimSetEntry(DimesionValues."Dimension Code", DimesionValues.Code, 0);
                DimSetID := DimensionSetEntry.GetDimensionSetID(TempDimensionSetEntry);
            end;
        end;
        if Dimensions.Get(GenLedgSetup."Global Dimension 2 Code") then begin
            if DimesionValues.Get(Dimensions.Code, DimensionCodePar2) then begin
                if DimSetID <> 0 then
                    InitDimSetEntry(DimesionValues."Dimension Code", DimesionValues.Code, DimSetID)
                else begin
                    InitDimSetEntry(DimesionValues."Dimension Code", DimesionValues.Code, 0);
                    DimSetID := DimensionSetEntry.GetDimensionSetID(TempDimensionSetEntry);
                end;
            end;
        end;
    end;

    local procedure InitDimSetEntry(DimCode: Code[20]; DimValue: Code[20]; DimID: Integer)
    begin
        TempDimensionSetEntry.DeleteAll();
        TempDimensionSetEntry.Init();
        TempDimensionSetEntry.Validate("Dimension Code", DimCode);
        TempDimensionSetEntry.Validate("Dimension Value Code", DimValue);
        TempDimensionSetEntry."Dimension Set ID" := DimID;
        TempDimensionSetEntry.Insert();
    end;

    var
        myInt: Integer;
        ExcelBufferTe: Record "Excel Buffer" temporary;
        IStream: InStream;
        SheetName: Text[100];
        FileName: Text[100];
        GLEntryGrec: Record "G/L Entry";
        TotalColumns: Integer;
        TotalRows: Integer;
        ImportMsg: Label 'Import Dimensions Completed';
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionSetID: Integer;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        DimensionCode: Code[20];
}