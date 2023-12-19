reportextension 50006 ProdOrderCompandRouting extends "Prod. Order Comp. and Routing"
{
    dataset
    {
        add("Production Order")
        {
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {

            }
            column(ProdLineNoLbl; ProdLineNoLbl)
            {

            }
            column(Qtycap; Qtycap)
            { }
            column(ItemNoCap; ItemNoCap)
            { }
            column(Description2label; Description2label)
            { }
            column(WorkDescription_ProductionOrder; WorkDescription)
            {
            }
            column(ShowDeImage; ShowDeImage)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
        }
        add("Prod. Order Component")
        {
            column(VendorItemNo; VendorItemNo)
            {
            }
            column(Description_2; "Description 2")
            {
                IncludeCaption = true;
            }
            column(UnitOfMeasure; UnitOfMeasure)
            { }
        }
        modify("Production Order")
        {
            trigger OnAfterAfterGetRecord()
            var
                i: Integer;
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";
                Currency: Record Currency;
                PaymentTerms: Record "Payment Terms";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                WorkDescription := GetWorkDescription();
                languageCodevar.Reset();
                languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                if languageCodevar.FindFirst() then
                    if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                        ShowEngImage := true;
                        ShowDEImage := false;
                    end
                    else begin
                        ShowEngImage := false;
                        ShowDEImage := true;
                    end;
            end;

        }
        modify("Prod. Order Component")
        {
            trigger OnAfterAfterGetRecord()
            var
                ItemRec: Record Item;
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
            begin
                if not ItemRec.Get("Item No.") then
                    Clear(ItemRec);
                if ItemRec."Vendor Item No." <> '' then
                    VendorItemNo := ItemRec."Vendor Item No."
                else
                    if ItemRec."Manufacturer Item No." <> '' then
                        VendorItemNo := ItemRec."Manufacturer Item No.";
                if "Unit of Measure Code" = '' then
                    UnitOfMeasure := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure := UnitOfMeasureRec.Description;
                    languageCodevar.Reset();
                    languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                    if not languageCodevar.FindFirst() then
                        languageCodevar.Init();
                    UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                    UnitOfMeasureTranslation.SetRange("Language Code", languageCodevar.Code);
                    if UnitOfMeasureTranslation.FindFirst() then
                        UnitOfMeasure := UnitOfMeasureTranslation.Description;
                end;
            end;
        }
    }
    rendering
    {
        layout(CustomLayout)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\ProdOrderCompandRouting.rdl';
        }
    }
    trigger OnPreReport()
    var
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        RespCenter: Record "Responsibility Center";
        Currency: Record Currency;
        PaymentTerms: Record "Payment Terms";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        FormatAddr.GetCompanyAddr('', RespCenter, CompanyInfo, CompanyAddress);
        for i := 1 to ArrayLen(CompanyAddress) do begin
            if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                CompanyAdd := CompanyAddress[i]
            else
                if CompanyAddress[i] <> '' then
                    CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        ProdLineNoLbl: Label 'Prod. Order Line No.';
        WorkDescription: Text;
        VendorItemNo: Text[50];
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        ShowDeImage: Boolean;
        ShowEngImage: Boolean;
        languageCodevar: Record Language;
        UnitOfMeasure: text[100];
        ItemNoCap: label 'Item No.';
        Description2label: label 'Description 2';
        Qtycap: Label 'QTY';
}
