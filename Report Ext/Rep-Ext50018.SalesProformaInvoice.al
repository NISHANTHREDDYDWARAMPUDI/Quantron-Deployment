reportextension 50018 SalesProformaInvoice extends "Standard Sales - Pro Forma Inv"
{
    dataset
    {
        add(Header)
        {
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(PaymentTermsCap; PaymentTermsCap)
            { }
            column(CreditTermsCap; CreditTermsCap)
            { }
            column(OrderdateCap; OrderdateCap)
            { }
            column(OrderNoCap; OrderNoCap)
            { }
            column(TermsofdeliveryCap; TermsofdeliveryCap)
            { }
            column(InvoicedateCap; InvoicedateCap)
            { }
            column(CustomerNoCap; CustomerNoCap)
            { }
            column(VATNoCap; VATNoCap)
            { }
            column(YourReferenceCap; YourReferenceCap)
            { }
            column(DuedateCap; DuedateCap)
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(Order_No_; "No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            { }
            column(VAT_Registration_No_; "VAT Registration No.")
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(Order_Date; "Order Date")
            { }
            column(Due_Date; "Due Date")
            { }
            column(ShipmentMethod_description; ShipmentMethod.Code)
            { }
            column(DocumentCaption; DocumentCaption)
            { }
            column(ArticleDesCap; ArticleDesCap)
            { }
            column(PieceTimeCap; PieceTimeCap)
            { }
            column(UnitPriceCap; UnitPriceCap)
            { }
            column(AmountCap; AmountCap)
            { }
            column(NetTotalCap; NetTotalCap)
            { }
            column(VatPerCap; VatPerCap)
            { }
            column(InvAmtCap; InvAmtCap)
            { }
            column(DownPaymtText; DownPaymtText)
            { }
            column(TotalAmtText; TotalAmtText)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(FooterText; FooterText)
            { }
            column(PCSCap; PCSCap)
            { }
            column(TotalExclVatCap; TotalExclVatCap)
            { }
            column(VatAmountCap; VatAmountCap)
            { }
            column(TotalInclVatCap; TotalInclVatCap)
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            //B2BDNROn10May2023>>
            column(DescriptionVar; DescriptionVar)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(ShipmentDatecap; ShipmentDatecap)
            { }
            column(Shipment_Date1; "Shipment Date")
            { }
            //B2BDNROn10May2023<<
            column(ShipToAddress1; ShipToAddr[1])
            {
            }
            column(ShipToAddress2; ShipToAddr[2])
            {
            }
            column(ShipToAddress3; ShipToAddr[3])
            {
            }
            column(ShipToAddress4; ShipToAddr[4])
            {
            }
            column(ShipToAddress5; ShipToAddr[5])
            {
            }
            column(ShipToAddress6; ShipToAddr[6])
            {
            }
            column(ShipToAddress7; ShipToAddr[7])
            {
            }
            column(ShipToAddress8; ShipToAddr[8])
            {
            }
            column(WorkDescriptionCap; WorkDescriptionCap)
            { }
        }
        add(Line)
        {
            column(ItemNo_Line_Lbl; FieldCaption("No."))
            {
            }
            column(ItemNo_Line; "No.")
            {
            }
            column(Quantity_Line; FormattedQuantity)
            {
            }
            column(LineNo_Line; "Line No.")
            {
            }
            column(Description_Line; Description)
            {
            }
            column(GrossWeightCap; GrossWeightCap)
            {
            }
            column(NetWeightCap; NetWeightCap)
            {
            }
            column(GrossWeight_Line; "Gross Weight")
            {
            }
            column(NetWeight_Line; "Net Weight")
            {
            }
            column(TariffNo; TariffNo)
            {
            }
            column(TariffNoCap; TariffNoCap)
            {
            }
            column(SalesInvoiceLineDiscount_Lbl; SalesInvLineDiscLbl)
            {
            }
            column(LineDiscountPercentText_Line; LineDiscountPctText)
            {
            }
            column(VATPct_VatAmountLine; "VAT %")
            {
                DecimalPlaces = 0 : 5;
            }
        }
        add(Totals)
        {
            column(CurrencySymbol; CurrSymbol)
            {
            }
        }
        addlast(Line)
        {
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                column(Entry_No_; TempTrackingSpecBuffer."Entry No.") { }
                column(TempTrackingSpecBuffer_ExpirationDate; TempTrackingSpecBuffer."Expiration Date") { }
                column(TempTrackingSpecBuffer_SerialNo; TempTrackingSpecBuffer."Serial No.") { }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OK := TempTrackingSpecBuffer.Find('-')
                    else
                        OK := TempTrackingSpecBuffer.Next <> 0;
                    if not OK then
                        CurrReport.Break();
                end;
            }
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                SalesInvHdr: Record "Sales Invoice Header";
                i: Integer;
                CountryRec: Record "Country/Region";
                CustomerRec: Record Customer;
                CurrCodeVar: Code[20];
                CurrencyRec: Record Currency;
                GeneralLedgerSetup: Record "General Ledger Setup";
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";
                CompanyInfo: Record "Company Information";
                CurrencyRec2: Record Currency;
            begin
                Footertext := '';
                CompanyInfo.Get();
                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddress);
                for i := 1 to ArrayLen(CompanyAddress) do begin
                    if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                        CompanyAdd := CompanyAddress[i]
                    else
                        if CompanyAddress[i] <> '' then
                            CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
                end;

                if not CountryRec.Get("Bill-to Country/Region Code") then
                    Clear(CountryRec);
                for i := 1 to ArrayLen(CustomerAddress) do begin
                    if CustomerAddress[i] = CountryRec.Name then
                        CustomerAddress[i] := UpperCase(CountryRec.Name);
                end;
                if not ShipmentMethod.Get(Header."Shipment Method Code") then
                    Clear(ShipmentMethod);
                if not PaymentTerms.Get("Payment Terms Code") then
                    Clear(PaymentTerms);
                if not CountryRec.Get("Ship-to Country/Region Code") then
                    Clear(CountryRec);
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustomerAddress, Header);
                for i := 1 to ArrayLen(ShipToAddr) do begin
                    if ShipToAddr[i] = CountryRec.Name then
                        ShipToAddr[i] := UpperCase(CountryRec.Name);
                end;
                if not CustomerRec.Get("Sell-to Customer No.") then
                    Clear(CustomerRec);
                if "VAT Registration No." = '' then
                    "VAT Registration No." := CustomerRec."VAT Registration No.";
                CalcFields("Amount Including VAT", Amount);
                DocumentCaption := ProformaInvCaption;
                //B2BDNROn10May2023>>
                if Header."Language Code" <> '' then
                    if languageCodevar.Get(Header."Language Code") then begin
                        if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                            DescriptionVar := PaymentTerms."English Description";
                            ShowEngImage := true;
                            ShowDEImage := false;
                        end else begin
                            DescriptionVar := PaymentTerms.Description;
                            ShowEngImage := false;
                            ShowDEImage := true;
                        end;
                    end else begin
                        DescriptionVar := PaymentTerms.Description;
                        ShowEngImage := false;
                        ShowDEImage := true;
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

                //B2BDNROn10May2023<<
            end;
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
                ItemLRec: Record Item;
                FormatDocument: Codeunit "Format Document";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                if Header."Currency Code" <> '' then begin
                    if Currency.Get(Header."Currency Code") then
                        CurrSymbol := Currency.GetCurrencySymbol();
                end else
                    if GeneralLedgerSetup.Get() then
                        CurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();
                if Quantity <> 0 then
                    FormattedLinePrice := FormattedLinePrice + ' ' + CurrSymbol;
                if "Line Discount %" = 0 then
                    LineDiscountPctText := ''
                else
                    LineDiscountPctText := StrSubstNo('%1%', -Round("Line Discount %", 0.1));
                FormatDocument.SetSalesLine(Line, FormattedQuantity, FormattedUnitPrice, FormattedVATPct, FormattedLineAmount);
                Clear(TariffNo);
                TempTrackingSpecBuffer.DeleteAll();
                If ItemLRec.Get("No.") then begin
                    TariffNo := ItemLRec."Tariff No.";
                    if ItemLRec."Item Tracking Code" <> '' then
                        ItemTrackingDoc.FindReservEntries(TempTrackingSpecBuffer, Database::"Sales Line", 1, "Document No.", '', 0, "Line No.", '');
                end;
            end;
        }
        modify(Totals)
        {
            trigger OnAfterAfterGetRecord()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                if Header."Currency Code" <> '' then begin
                    if Currency.Get(Header."Currency Code") then
                        CurrSymbol := Currency.GetCurrencySymbol();
                end else
                    if GeneralLedgerSetup.Get() then
                        CurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();

            end;
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout(CustomLayout)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Sales Proforma Invoice.rdl';
        }
    }
    var
        TempTrackingSpecBuffer: Record "Tracking Specification" temporary;
        OK: Boolean;
        FormattedQuantity: Text;
        FormattedUnitPrice: Text;
        FormattedVATPct: Text;
        DocumentCaption: Text[100];
        DownPaymtText: Text[250];
        TotalAmtText: Text[150];
        CountryName: Code[100];
        CompanyAdd: Text[500];
        Footertext: Text[250];
        ShipToAddr: array[8] of Text[100];
        TariffNo: Code[20];
        CurrSymbol: Text[10];
        LineDiscountPctText: Text;
        SalesInvLineDiscLbl: Label 'Discount %';
        TariffNoCap: Label 'Tariff No.';
        ShipToaddCap: Label 'Delivery Address';
        PaymentTermsCap: Label 'Payment Term';
        CreditTermsCap: Label 'Term of payment';
        OrderNoCap: Label 'Order Number';
        TermsofdeliveryCap: Label 'Delivery Condition';
        InvoicedateCap: Label 'Invoice date';
        CustomerNoCap: Label 'Customer Number';
        VATNoCap: Label 'VAT ID';
        YourReferenceCap: Label 'Your Reference';
        OrderdateCap: Label 'Order Date';
        DuedateCap: Label 'Due date';
        GrossWeightCap: Label 'Gross Weight:';
        NetWeightCap: Label 'Net Weight:';
        ProformaInvCap: Label 'PrePayment Invoice';
        ProformaInvCaption: Label 'Proforma Invoice';
        DownPayInvCap: Label 'Down Payment Invoice';
        TaxInvoiceCap: Label 'TAX Invoice';
        TaxFreeInvoiceCap: Label 'TAX Free Invoice';
        FinalInvoiceLbl: Label 'Final Invoice';
        ArticleDesCap: Label 'Description';
        PieceTimeCap: Label 'Amount/Time';
        UnitPriceCap: Label 'Unit Price';
        AmountCap: Label 'Amount';
        NetTotalCap: Label 'total net';
        VatPerCap: Label 'plus VAT.';
        InvAmtCap: Label 'Invoice amount';
        DownPaymtInvText: Label 'down payment invoice (%1) for the order dated %2, %3';
        DownPaymtAmtText: Label 'Total amount: %1,- %2';
        PPCap: Label 'PP';
        FooterTextCaption: Label 'According to §4 No.1b tax-free intra-community delivery.';
        PCSCap: Label 'PCS';
        TotalExclVatCap: Label 'Total excl.VAT';
        VatAmountCap: Label 'VAT Amount';
        TotalInclVatCap: Label 'Total incl.VAT';
        SerialNoCap: Label 'Serial No.';
        CurrecySymbol1: Text[10];
        DescriptionVar: Text[100];
        ShowEngImage: Boolean;
        ShowDEImage: Boolean;
        ShipmentDatecap: Label 'Shipment Date';
        languageCodevar: Record Language;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        WorkDescriptionCap: Label 'Work Description';
}
