report 50008 "Internal Shipment"
{
    ApplicationArea = All;
    Caption = 'Internal Shipment';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Internal Shipment.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(DirectTransHeader; "Direct Trans. Header")
        {
            RequestFilterFields = "No.";
            column(CompanyAdd; CompanyAdd)
            { }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(DescriptionCap; DescriptionCap)
            { }
            column(DocumentTitle_Lbl; DocumentTitle_Lbl)
            { }
            column(ItemNoCap; ItemNoCap)
            { }
            column(No_DirectTransHeader; "No.")
            {
            }
            column(PageCap; PageCap)
            { }
            column(PostingDate_DirectTransHeader; "Posting Date")
            {
            }
            column(QuantityCap; QuantityCap)
            { }
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(Transfer_from_Contact; "Transfer-from Contact")
            { }
            column(Transfer_to_City; "Transfer-to City")
            { }
            column(Transfer_to_Contact; "Transfer-to Contact")
            { }
            column(Transfer_to_Post_Code; "Transfer-to Post Code")
            { }
            column(TransferfromAddress2_DirectTransHeader; "Transfer-from Address 2")
            { }
            column(TransferfromAddress_DirectTransHeader; "Transfer-from Address")
            {
            }
            column(TransferfromCity_DirectTransHeader; "Transfer-from City")
            { }
            column(TransferfromCode_DirectTransHeader; "Transfer-from Code")
            { }

            column(TransferfromName_DirectTransHeader; "Transfer-from Name")
            {
            }
            column(TransferfromPostCode_DirectTransHeader; "Transfer-from Post Code")
            {
            }
            column(TransfertoAddress2_DirectTransHeader; "Transfer-to Address 2")
            {
            }
            column(TransfertoAddress_DirectTransHeader; "Transfer-to Address")
            {
            }
            column(TransfertoCode_DirectTransHeader; "Transfer-to Code")
            {
            }
            column(TransfertoName_DirectTransHeader; "Transfer-to Name")
            {
            }
            column(UnitOfMeasureCodeCap; UnitOfMeasureCodeCap)
            {

            }
            dataitem("Direct Trans. Line"; "Direct Trans. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = DirectTransHeader;

                column(Description2_DirectTransLine; "Description 2")
                {
                }
                column(Description_DirectTransLine; Description)
                {
                }
                column(DocumentNo_DirectTransLine; "Document No.")
                {
                }

                column(ItemNo_DirectTransLine; "Item No.")
                {
                }
                column(LineNo_DirectTransLine; "Line No.")
                {
                }
                column(Quantity_DirectTransLine; Quantity)
                {
                }
                column(TransferfromBinCode_DirectTransLine; "Transfer-from Bin Code")
                {
                }
                column(TransferfromCode_DirectTransLine; "Transfer-from Code")
                {
                }
                column(TransferToBinCode_DirectTransLine; "Transfer-To Bin Code")
                {
                }
                column(TransfertoCode_DirectTransLine; "Transfer-to Code")
                {
                }
                column(UnitofMeasure_DirectTransLine; "Unit of Measure")
                {
                }
                column(UnitofMeasureCode_DirectTransLine; "Unit of Measure Code")
                {
                }

            }
            trigger OnAfterGetRecord()
            var
                languageCodevar: Record Language;
                RespCenter: Record "Responsibility Center";
                FormatAddr: Codeunit "Format Address";
                i: Integer;
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
            end;
        }
    }
    var
        CompanyInfo: Record "Company Information";
        ShowDEImage: Boolean;
        ShowEngImage: Boolean;
        DescriptionCap: label 'Description';
        DocumentTitle_Lbl: label 'Internal Shipment';
        ItemNoCap: Label 'Item No.';
        PageCap: Label 'Page';
        QuantityCap: label 'Quantity';
        ShipToaddCap: Label 'Delivery Address';
        UnitOfMeasureCodeCap: label 'Unit Of Measure Code';
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
}
