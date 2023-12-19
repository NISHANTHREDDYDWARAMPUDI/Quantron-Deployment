reportextension 50007 Purchaseorder extends "Standard Purchase - Order"
{
    //B2BDNROn16May2023>>
    dataset
    {
        add("Purchase Header")
        {
            column(ShowEngImage; ShowEngImage)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(TotalExcVat_label; TotalExcVat)
            { }
            column(TotalIncVat_label; TotalIncVat)
            { }
            column(ExlVatAmt; ExlVatAmt)
            { }
            column(InclVatAmt; InclVatAmt)
            { }
            column(VatamountTotal; VatamountTotal)
            { }
            column(BottomText; BottomText)
            { }
            column(BottomText1; BottomText1)
            { }
            column(BottomTextEngBody; BottomTextEngBody)
            { }
            column(BottomTextLink; BottomTextLink)
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(PaymentTermsCap; PaymentTermsCap)
            { }
            column(TermsofdeliveryCap; TermsofdeliveryCap)
            { }
            column(ShipmentMethodCode; ShipmentMethod.Code)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(QtyCap; QtyCap)
            { }
            column(UnitCost; UnitCost)
            { }
            column(CurrSymbol; CurrSymbol)
            { }
            column(DescriptionVar; DescriptionVar)
            { }
            column(BuyerCap; BuyerCap)
            { }
            column(ReceiveByCap; ReceiveByCap)
            { }
            column(PosCap; PosCap)
            { }
            column(TotalExcVat; TotalExcVat)
            { }
            column(TotalIncVat; TotalIncVat)
            { }
            column(PromisedReceiptDateCap; PromisedReceiptDateCap)
            { }


        }
        add("Purchase Line")
        {
            column(Document_No_; "Document No.")
            { }
            column(Line_No_; "Line No.")
            { }
            column(UnitOfMeasure; UnitOfMeasure)
            { }
            column(Promised_Receipt_Date; "Promised Receipt Date")
            { }
        }
        modify("Purchase Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                Purchaselines: Record "Purchase Line";
                RespCenter: Record "Responsibility Center";
                Currency: Record Currency;
                GeneralLedgerSetup: Record "General Ledger Setup";

            begin
                clear(ExlVatAmt);
                clear(InclVatAmt);
                if "Purchase Header"."Language Code" <> '' then
                    if languageCodevar.Get("Purchase Header"."Language Code") then begin
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
                if Currency.Get("Currency Code") then
                    CurrSymbol := Currency.GetCurrencySymbol()
                else
                    if GeneralLedgerSetup.Get() then begin
                        CurrCode := GeneralLedgerSetup."LCY Code";
                        CurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();
                    end;

                Purchaselines.SetAutoCalcFields();
                Purchaselines.Reset();
                Purchaselines.SetRange("Document No.", "Purchase Header"."No.");
                Purchaselines.SetRange("Document Type", "Purchase Header"."Document Type");
                if Purchaselines.FindFirst() then begin
                    repeat
                        ExlVatAmt += Purchaselines.Amount;
                        InclVatAmt += Purchaselines."Amount Including VAT";
                    until Purchaselines.Next = 0;
                    VatamountTotal := InclVatAmt - ExlVatAmt;
                end;
            end;
        }
        modify("Purchase Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
            begin
                if "Unit of Measure Code" = '' then
                    UnitOfMeasure := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure := UnitOfMeasureRec.Description;
                    if "Purchase Header"."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", "Purchase Header"."Language Code");
                        if UnitOfMeasureTranslation.FindFirst() then
                            UnitOfMeasure := UnitOfMeasureTranslation.Description;
                    end else begin
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
            end;
        }
    }
    rendering
    {
        layout(CustomLayout)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\PurchaseOrder.rdl';
        }
    }
    trigger OnPreReport()
    var
        CompanyInfo: Record "Company Information";
        Purchaselines: Record "Purchase Line";
        FormatAddr: Codeunit "Format Address";
        RespCenter: Record "Responsibility Center";
        i: Integer;
        Currency: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";

    begin
        clear(CompanyAdd);
        CompanyInfo.Get();
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
        ShowEngImage: Boolean;
        ShowDeImage: Boolean;
        languageCodevar: Record Language;
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        TotalExcVat: Label 'Total excl.VAT';
        TotalIncVat: Label 'Total incl.VAT';
        ShipToaddCap: Label 'Delivery Address';
        QtyCap: Label 'Qty';
        UnitCost: Label 'Unit Cost';
        BuyerCap: Label 'Buyer';
        ReceiveByCap: Label 'Receive By';
        PosCap: Label 'Pos.';
        ExlVatAmt: Decimal;
        InclVatAmt: Decimal;
        VatamountTotal: Decimal;
        SerialNoCap: Label 'Serial No.';
        PaymentTermsCap: Label 'Payment Term';
        TermsofdeliveryCap: Label 'Delivery Condition';
        BottomText: label 'Please send us an Order Confirmation including confirmation of the delivery quantity, the desired goods receipt and stating our order number to the sender of the order';
        BottomText1: Label 'All invoices should be sent to the following address: e-invoicing@quantron.net.';

        BottomTextEngBody: label 'The general terms and conditions of Quantron AG apply to all orders. These are available under the following link.';
        BottomTextLink: label 'https://WWW.quantron.net/wp-content/uploads/2023/02/AEB_QuantronAG_2023.pdf';
        CurrSymbol: text[10];
        CurrCode: code[10];
        DescriptionVar: Text[200];
        UnitOfMeasure: Text[50];
        PromisedReceiptDateCap: Label 'Promised Receipt Date';

    //B2BDNROn16May2023<<


}