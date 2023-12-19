report 50009 "Item Label"
{
    ApplicationArea = All;
    Caption = 'Item Label';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\ItemLabel.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Posted Whse. Receipt Line"; "Posted Whse. Receipt Line")
        {
            RequestFilterFields = "No.";
            dataitem(Item; Item)
            {
                DataItemLink = "No." = field("Item No.");
                dataitem(CopyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    dataitem(PageLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                        column(Description; Item.Description)
                        { }
                        column(Description_2; item."Description 2")
                        { }
                        column(No_; Item."No.")
                        { }
                        column(QR_Code; QrString)
                        { }
                        column(Vendor_Item_No_; Item."Vendor Item No.")
                        { }
                        column(QR; Item."QR Code")
                        { }
                        column(OutputNo; OutputNo)
                        { }
                        column(NoOfCopies; NoOfCopies)
                        { }
                        column(CopyText; CopyText)
                        { }
                    }


                    trigger OnAfterGetRecord()
                    begin
                        if Number > 1 then
                            CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;

                    end;

                    trigger OnPreDataItem()

                    begin
                        NoOfLoops := Abs(NoOfCopies) + 1;
                        CopyText := '';
                        SetRange(Number, 1, NoOfLoops);
                        OutputNo := 1;

                    end;
                }
                trigger OnAfterGetRecord()
                var
                    QrGenSwiss: Codeunit "Swiss QR Code Helper";
                    TempBlob: Codeunit "Temp Blob";
                    InsStr: InStream;
                    OutStr: OutStream;
                begin
                    Clear(QrString);
                    clear(StockReciveNoGvar);
                    clear(InventoryGVar);
                    clear(InventoryGvar1);
                    Clear(TempBlob);
                    StockReciveNoGvar := "Posted Whse. Receipt Line"."No.";
                    StockKeepingUnitGrec.Reset();
                    StockKeepingUnitGrec.SetRange("Item No.", Item."No.");
                    StockKeepingUnitGrec.SetFilter(Inventory, '<>0');
                    if StockKeepingUnitGrec.FindSet() then
                        repeat
                            StockKeepingUnitGrec.CalcFields(Inventory);
                            InventoryGVar += '|' + StockKeepingUnitGrec."Location Code" + '-' + format(StockKeepingUnitGrec.Inventory);
                        until StockKeepingUnitGrec.next = 0;
                    InventoryGvar1 := CopyStr(InventoryGVar, 2, StrLen(InventoryGVar));
                    QrString := Item."No." + '|' + Item.Description + '|' + Item."Description 2" + '|' + Item."Vendor No." + '|' + Item."Vendor Item No." + '|' + Item."Manufacturer Code" + '|' + StockReciveNoGvar + '|' + InventoryGvar1;
                    QrGenSwiss.GenerateQRCodeImage(QrString, TempBlob);
                    TempBlob.CreateInStream(InsStr);
                    Item."QR Code".CreateOutStream(OutStr);
                    CopyStream(OutStr, InsStr);
                    Item.CalcFields("QR Code");
                end;
            }


        }
    }
    requestpage
    {

        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Service;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }

                }
            }
        }
    }





    var
        QrString: Text;
        WareHouseReciptLineGRe: Record "Warehouse Receipt Line";
        StockReciveNoGvar: code[20];
        StockKeepingUnitGrec: record "Stockkeeping Unit";
        InventoryGVar: Text;
        InventoryGvar1: Text;
        PostedWhrRecpitlines: record "Posted Whse. Receipt Line";
        NoOfCopies: Integer;
        CopyText: Text[30];
        NoOfLoops: Integer;
        OutputNo: Integer;
        Text004: Label 'COPY';
        FormatDocument: Codeunit "Format Document";


}
