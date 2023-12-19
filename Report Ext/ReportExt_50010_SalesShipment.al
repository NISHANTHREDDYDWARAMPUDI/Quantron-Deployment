reportextension 50010 SalesShipment extends "Standard Sales - Shipment"
{
    //B2BDNROn20May2023>>
    dataset
    {
        add(Header)
        {
            column(ShipmentMethodCode; ShipmentMethod.Code)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(Order_Date; "Order Date")
            { }
            column(ShipmentDate_Header; "Shipment Date")
            { }
            column(DocumentDate_Header; "Document Date")
            { }
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
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(OrderNoCap; OrderNoCap)
            { }
            column(TermsofdeliveryCap; TermsofdeliveryCap)
            { }
            column(YourReferenceCap; YourReferenceCap)
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            column(OrderdateCap; OrderdateCap)
            { }
            column(CustomerNoCap; CustomerNoCap)
            { }
            column(QtyCap; QtyCap)
            { }
            column(UnitCap; UnitCap)
            { }
            column(Salespersoncap; Salespersoncap)
            { }
            column(ShipmentNoCap; ShipmentNoCap)
            { }
            column(Nocap; Nocap)
            { }
            column(Description; Description)
            { }
            column(PaymentTermCap; PaymentTermCap)
            { }
            column(DocumentDateCap; DocumentDateCap)
            { }
            column(NetWeightCap; NetWeightCap)
            { }
            column(TotalNetWeightCap; TotalNetWeightCap)
            { }
            column(Totalweightcap; Totalweightcap)
            { }
            column(KGCap; KGCap)
            { }
            column(Total_Gross_Weight; "Total Gross Weight")
            { }
            column(TotalMeasurementCap; TotalMeasurementCap)
            { }
            column(Total_Measurements; "Total Measurements")
            { }
        }
        add(Line)
        {
            column(UnitOfMeasure1; UnitOfMeasure1)
            { }
            column(Weight; Weight)
            { }
            column(LineQuantity; Quantity)
            { }
            column(Description_2; "Description 2")
            { }
            column(Netweight; Netweight)
            { }
        }
        addafter(AssemblyLine)
        {
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                column(Quantity; TempItemLedEntry.Quantity)
                { }
                column(Entry_No_; TempItemLedEntry."Entry No.")
                { }
                column(TempItemLedEntry_ExpirationDate; TempItemLedEntry."Expiration Date")
                { }
                column(TempItemLedEntry_SerialNo; TempItemLedEntry."Serial No.")
                { }

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
                i: Integer;
                CountryRec: Record "Country/Region";
                CompanyInfo: Record "Company Information";
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";
                PaymentTerms: Record "Payment Terms";
            begin
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
                if PaymentTerms.Get("Payment Terms Code") then begin
                    if Header."Language Code" <> '' then begin
                        if languageCodevar.Get(Header."Language Code") then begin
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
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ItemRec: Record Item;
            begin
                Clear(Netweight);
                Clear(Weight);
                //  CHB2B11SEP2023<<
                if (Type = Type::Item) and (Quantity = 0) then
                    CurrReport.Skip();
                // CHB2B11SEP2023<<

                TempItemLedEntry.DeleteAll();
                ItemTrackingDoc.RetrieveEntriesFromShptRcpt(TempItemLedEntry, DATABASE::"Sales Shipment Line", 0, "Document No.", '', 0, "Line No.");
                if "Unit of Measure Code" = '' then
                    UnitOfMeasure1 := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure1 := UnitOfMeasureRec.Description;
                    if Header."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", Header."Language Code");
                        if UnitOfMeasureTranslation.FindFirst() then
                            UnitOfMeasure1 := UnitOfMeasureTranslation.Description;
                    end else begin
                        languageCodevar.Reset();
                        languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                        if not languageCodevar.FindFirst() then
                            languageCodevar.Init();
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", languageCodevar.Code);
                        if UnitOfMeasureTranslation.FindFirst() then
                            UnitOfMeasure1 := UnitOfMeasureTranslation.Description;
                    end;
                end;
                if ItemRec.Get("No.") then
                    if ItemRec."Net Weight" <> 0 then
                        Netweight := ItemRec."Net Weight"
                    else
                        Netweight := "Net Weight";
                Weight := Quantity * Netweight;
            end;
        }
    }

    requestpage
    {

    }

    rendering
    {
        layout(CustomLayout)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Sales Shipment.rdl';
        }
    }
    var
        languageCodevar: Record Language;
        TempItemLedEntry: Record "Item Ledger Entry" temporary;
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        DescriptionVar: Text[100];
        ShowEngImage: Boolean;
        ShowDEImage: Boolean;
        OK: Boolean;
        UnitOfMeasure1: Text[50];
        ShipmentDatecap: Label 'Shipment Date';
        ShipToaddCap: Label 'Delivery Address';
        OrderNoCap: Label 'Order Number';
        TermsofdeliveryCap: Label 'Delivery Condition';
        SerialNoCap: Label 'Serial No.';
        YourReferenceCap: Label 'Your Reference';
        OrderdateCap: Label 'Order Date';
        CustomerNoCap: Label 'Customer Number';
        QtyCap: Label 'Qty';
        UnitCap: Label 'Unit';
        Salespersoncap: Label 'Sales Person';
        ShipmentNoCap: Label 'Shipment No.';
        Nocap: Label 'No.';
        Description: Label 'Description';
        PaymentTermCap: Label 'Payment Term';
        DocumentDateCap: Label 'Document Date';
        NetWeightCap: Label 'Net Weight';
        TotalNetWeightCap: label 'Total weight';
        Totalweightcap: label 'Total Gross Weight';
        TotalMeasurementCap: Label 'Total Measurements';
        Weight: Decimal;
        Netweight: Decimal;
        KGCap: Label 'KG';

    //B2BDNROn20May2023<<
}