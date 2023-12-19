reportextension 50005 "Sales Invoice" extends "Standard Sales - Invoice"
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
            column(Order_No_; "Order No.")
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
            column(PaymentTerms_Description; PaymentTerms.Description)
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
            column(WorkDescriptionCap; WorkDescriptionCap)
            { }
            column(No_; "No.")
            { }
            column(NoVar; NoVar)
            { }
            column(DescriptionVar1; DescriptionVar1)
            { }
            column(DocumenttypeVar; DocumenttypeVar)
            { }
            //B2BDNROn10May2023<<
        }
        add(Line)
        {
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

        }
        addafter(AssemblyLine)
        {
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                column(Quantity; TempItemLedEntry.Quantity) { }
                column(Entry_No_; TempItemLedEntry."Entry No.") { }
                column(TempItemLedEntry_ExpirationDate; TempItemLedEntry."Expiration Date") { }
                column(TempItemLedEntry_SerialNo; TempItemLedEntry."Serial No.") { }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OK := TempItemLedEntry.Find('-')
                    else
                        OK := TempItemLedEntry.Next <> 0;
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
                for i := 1 to ArrayLen(CustAddr) do begin
                    if CustAddr[i] = CountryRec.Name then
                        CustAddr[i] := UpperCase(CountryRec.Name);
                end;

                if not CountryRec.Get("Ship-to Country/Region Code") then
                    Clear(CountryRec);
                for i := 1 to ArrayLen(ShipToAddr) do begin
                    if ShipToAddr[i] = CountryRec.Name then
                        ShipToAddr[i] := UpperCase(CountryRec.Name);
                end;
                if not CustomerRec.Get("Sell-to Customer No.") then
                    Clear(CustomerRec);
                if "VAT Registration No." = '' then
                    "VAT Registration No." := CustomerRec."VAT Registration No.";
                CalcFields("Amount Including VAT", Amount);

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
                if Header."Prepayment Invoice" then begin
                    NoVar := Header."No.";
                    DescriptionVar := Header."Your Reference";
                end;
                PaymentTerms.Reset();
                PaymentTerms.SetRange(Code, "Payment Terms Code");
                if PaymentTerms.FindFirst() then
                    DocumenttypeVar := Format(PaymentTerms."Invoice Type");

                SalesInvHdr.Reset();
                SalesInvHdr.SetRange("Prepayment Order No.", "Order No.");
                if SalesInvHdr.FindFirst() and (not "Prepayment Invoice") then begin
                    SalesInvHdr.CalcFields("Amount Including VAT");
                    DownPaymtText := SalesInvHdr."No.";
                    CurrCodeVar := SalesInvHdr."Currency Code";
                    if CurrencyRec.Get("Currency Code") then
                        CurrCodeVar := CurrencyRec.Code
                    else
                        if GeneralLedgerSetup.Get() then
                            CurrCodeVar := GeneralLedgerSetup."LCY Code";
                    TotalAmtText := StrSubstNo(DownPaymtAmtText, SalesInvHdr."Amount Including VAT", CurrCodeVar);
                end;

                case PaymentTerms."Invoice Type" of
                    PaymentTerms."Invoice Type"::" ":
                        begin
                            SalesInvHdr.Reset();
                            SalesInvHdr.SetRange("Prepayment Order No.", "Order No.");
                            if SalesInvHdr.IsEmpty() then
                                DocumentCaption := Invoicecap
                            else
                                DocumentCaption := FinalInvoiceLbl;
                        end;


                    PaymentTerms."Invoice Type"::"Down Payment":
                        DocumentCaption := DownPayInvCap;

                    PaymentTerms."Invoice Type"::"Pre Payment":
                        DocumentCaption := ProformaInvCap;

                end;

                if SalesInvHdr."Customer Posting Group" = 'EU' then
                    Footertext := FooterTextCaption
                else
                    Footertext := '';
            end;
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
            begin
                TempItemLedEntry.DeleteAll();
                ItemTrackingDoc.RetrieveEntriesFromPostedInvoice(TempItemLedEntry, Line.RowID1());
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
            LayoutFile = 'Report Ext\Layouts\Sales Invoice.rdl';
        }
    }
    var
        TempItemLedEntry: Record "Item Ledger Entry" temporary;
        OK: Boolean;
        DocumentCaption: Text[100];
        DownPaymtText: Text[250];
        TotalAmtText: Text[150];
        CountryName: Code[100];
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        Footertext: Text[250];
        ShipToaddCap: Label 'Delivery Address';
        PaymentTermsCap: Label 'Payment Term';
        CreditTermsCap: Label 'Term of payment';
        OrderNoCap: Label 'Order Number';
        TermsofdeliveryCap: Label 'Delivery Condition';
        InvoicedateCap: Label 'Invoice date';
        CustomerNoCap: Label 'Customer Number';
        VATNoCap: Label 'VAT ID';
        NoVar: Code[20];
        DescriptionVar1: Text[50];
        DocumenttypeVar: Text[50];
        PaymenttermsRec: Record "Payment Terms";
        YourReferenceCap: Label 'Your Reference';
        OrderdateCap: Label 'Order Date';
        DuedateCap: Label 'Due date';
        GrossWeightCap: Label 'Gross Weight:';
        NetWeightCap: Label 'Net Weight:';
        ProformaInvCap: Label 'PrePayment Invoice';
        DownPayInvCap: Label 'Down Payment Invoice';
        TaxInvoiceCap: Label 'TAX Invoice';
        TaxFreeInvoiceCap: Label 'TAX Free Invoice';
        FinalInvoiceLbl: Label 'Final Invoice';
        Invoicecap: Label 'Invoice';
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
        WorkDescriptionCap: Label 'Work Description';
        languageCodevar: Record Language;
}