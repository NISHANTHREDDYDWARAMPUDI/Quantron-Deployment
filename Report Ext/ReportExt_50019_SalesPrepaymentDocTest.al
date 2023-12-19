reportextension 50019 SalePrepaymentDocumentTest extends "Sales Prepmt. Document Test"
{
    dataset
    {
        add("Sales Header")
        {
            column(ShowDeImage; ShowDeImage)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(CompanyPicture; CompanyInfo.Picture)
            { }
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(Page_Lbl; Page_Lbl)
            { }
            column(DescriptionVar; DescriptionVar)
            { }
            column(YourReferenceCap; YourReferenceCap)
            { }
            column(Order_Date; "Order Date")
            { }
            column(ShipmentDate_Header; "Shipment Date")
            { }
            column(DocumentDate_Header; "Document Date")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Prepayment_Due_Date; "Prepayment Due Date")
            { }
            column(Prepmt__Pmt__Discount_Date; "Prepmt. Pmt. Discount Date")
            { }
            Column(SalespersonCodeCap; SalespersonCodeCap)
            { }
            Column(PrepmtDuedateCap; PrepmtDuedateCap)
            { }
            Column(PrepmtDiscountdateCap; PrepmtDiscountdateCap)
            { }
            Column(OrderdateCap; OrderdateCap)
            { }
            Column(ShipmentDateCap; ShipmentDateCap)
            { }
            Column(DocumentDateCap; DocumentDateCap)
            { }
            Column(PostingdateCap; PostingdateCap)
            { }
            Column(PaymentTermCap; PaymentTermCap)
            { }
            Column(TermsofdeliveryCap; TermsofdeliveryCap)
            { }
            Column(ItemNoCap; ItemNoCap)
            { }
            column(DescriptionCap; DescriptionCap)
            { }
            column(QtyCap; QtyCap)
            { }
            column(LineAmountExclVatCap; LineAmountExclVatCap)
            { }
            column(PrepLineAmountExclVatCap; PrepLineAmountExclVatCap)
            { }
            column(PrepLineAmountInclVatCap; PrepLineAmountInclVatCap)
            { }
            column(PrepaymentCap; PrepaymentCap)
            { }
        }
        modify("Sales Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                i: Integer;
                CountryRec: Record "Country/Region";
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";
                PaymentTerms: Record "Payment Terms";
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddress);
                for i := 1 to ArrayLen(CompanyAddress) do begin
                    if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                        CompanyAdd := CompanyAddress[i]
                    else
                        if CompanyAddress[i] <> '' then
                            CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
                end;
                if PaymentTerms.Get("Payment Terms Code") then begin
                    if "Sales Header"."Language Code" <> '' then begin
                        if languageCodevar.Get("Sales Header"."Language Code") then begin
                            if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                                DescriptionVar := PaymentTerms."English Description";
                                ShowEngImage := true;
                                ShowDEImage := false;
                            end else begin
                                DescriptionVar := PaymentTerms.Description;
                                ShowEngImage := false;
                                ShowDEImage := true;
                            end
                        end else begin
                            DescriptionVar := PaymentTerms.Description;
                            ShowEngImage := false;
                            ShowDEImage := true;
                        end;
                    end
                    else begin
                        languageCodevar.Reset();
                        languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                        if languageCodevar.FindFirst() then
                            if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                                DescriptionVar := PaymentTerms."English Description";
                                ShowEngImage := true;
                                ShowDEImage := false;
                            end
                            else begin
                                DescriptionVar := PaymentTerms.Description;
                                ShowEngImage := false;
                                ShowDEImage := true;
                            end;
                    end;

                end;
            end;
        }
    }

    rendering
    {
        layout(CustomLayout)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Sales Prepayment Document Test.rdl';
        }
    }
    var
        CompanyAdd: Text[500];
        ShowEngImage: Boolean;
        ShowDEImage: Boolean;
        CompanyInfo: Record "Company Information";
        DescriptionVar: Text[100];
        CompanyAddress: array[8] of Text[100];
        ShipmentMethod: Record "Shipment Method";
        languageCodevar: Record Language;
        Page_Lbl: Label 'Page';
        ShipToaddCap: Label 'Delivery Address';
        YourReferenceCap: Label 'Your Reference';
        SalespersonCodeCap: Label 'Sales Person';
        PrepmtDuedateCap: Label 'Prepmt. Due Date';
        PrepmtDiscountdateCap: Label 'Prepmt. Discount Date';
        OrderdateCap: Label 'Order Date';
        ShipmentDateCap: Label 'Shipment Date';
        DocumentDateCap: Label 'Document Date';
        PostingdateCap: Label 'Posting Date';
        PaymentTermCap: Label 'Payment Term';
        TermsofdeliveryCap: Label 'Delivery Condition';
        ItemNoCap: Label 'No.';
        DescriptionCap: Label 'Description';
        QtyCap: Label 'QTY';
        LineAmountExclVatCap: Label 'Line Amount Excl. VAT';
        PrepLineAmountExclVatCap: Label 'Prepmt. Line Amount Excl. VAT';
        PrepLineAmountInclVatCap: Label 'Prepmt. Line Amount Incl. VAT';
        PrepaymentCap: Label 'Prepayment %';



}