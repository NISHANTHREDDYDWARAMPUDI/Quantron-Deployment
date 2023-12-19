reportextension 50009 ServiceShipment extends "Service - Shipment"
{
    dataset
    {
        add("Service Shipment Header")
        {
            column(AmountCap; AmountCap)
            { }
            column(ShipmentDateCap; ShipmentDateCap)
            { }
            column(AmountCapLbl; AmountCapLbl)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(DeliveryAddCap; DeliveryAddCap)
            { }
            column(LineCapLbl; LineCapLbl)
            { }
            column(PaymentTermCap; PaymentTermCap)
            { }
            column(ShiptoaddCapLbl; ShiptoaddCapLbl)
            { }
            column(TotalExclVatCap; TotalExclVatCap)
            { }
            column(TotalInclVatCap; TotalInclVatCap)
            { }
            column(UnitCap; UnitCap)
            { }
            column(UnitPriceCapLbl; UnitPriceCapLbl)
            { }
            column(VatAmountCap; VatAmountCap)
            { }
            column(DiscountCap; DiscountCap)
            { }
            column(OrderNumberCao; OrderNumberCao)
            { }
            column(InvoiceDateCap; InvoiceDateCap)
            { }
            column(StartDateCap; StartDateCap)
            { }
            column(OrderOpendateCap; OrderOpendateCap)
            { }
            column(AsignedUserIDCap; AsignedUserIDCap)
            { }
            column(ServiceordertypeCap; ServiceordertypeCap)
            { }
            column(Service_Order_Type; "Service Order Type")
            { }
            column(User_ID; "User ID")
            { }
            column(Starting_Date; "Starting Date")
            { }
            column(Order_No_; "Order No.")
            { }
            column(Document_Date; "Document Date")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(Customer_No_; "Customer No.")
            { }
            Column(DeliveryConditionCap; DeliveryConditionCap)
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(CustomerReference; CustomerReference)
            { }
            column(CustomerNoCapLbl; CustomerNoCapLbl)
            { }
            column(ServiceInvoiceHeaderDueDateCaption; ServiceInvoiceHeaderDueDateCaption)
            { }
            column(Due_Date; "Due Date")
            { }
            column(QtyConsumedCap; QtyConsumedCap)
            { }
            column(QtyCapLbl; QtyCapLbl)
            { }
            column(QtyInvoicedCap; QtyInvoicedCap)
            { }
            column(PageCap; PageCap)
            { }

        }
        add(PageLoop)
        {
            column(BrandCapLbl; BrandCapLbl)
            { }
            column(CustAddress1; CustAddress[1])
            {
            }
            column(CustAddress2; CustAddress[2])
            {
            }
            column(CustAddress3; CustAddress[3])
            {
            }
            column(CustAddress4; CustAddress[4])
            {
            }
            column(CustAddress5; CustAddress[5])
            {
            }
            column(CustAddress6; CustAddress[6])
            {
            }
            column(CustAddress7; CustAddress[7])
            {
            }
            column(CustAddress8; CustAddress[8])
            {
            }
            column(CustomerNoCap; CustomerNoCapLbl)
            { }
            column(DescriptionVar; DescriptionVar)
            { }
            column(KmCapLbl; KmCapLbl)
            { }
            column(ModelCapLbl; ModelCapLbl)
            { }
            column(OrderNo_ServShipHeader; "Service Shipment Header"."Order No.")
            { }
            column(OrderNoText2; OrderNoText2)
            { }
            column(PrintBool; PrintBool)
            { }
            column(RegCapLbl; RegCapLbl)
            { }
            column(RegDateCapLbl; RegDateCapLbl)
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            column(SerialNoCapLbl; SerialNoCapLbl)
            { }
            column(ServiceCapLbl; ServiceCapLbl)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(SPCapLbl; SPCapLbl)
            { }
            column(TUVCapLbl; TUVCapLbl)
            { }

        }
        add("Service Shipment Line")
        {
            column(Brand; Brand)
            { }
            column(ItemNo; ItemNo)
            { }
            column(KM; KM)
            { }
            column(Model; Model)
            { }
            column(PlateNo; PlateNo)
            { }
            column(RegDate; RegDate)
            { }
            column(SerialNo; SerialNo)
            { }
            column(ServiceItemNo_ServiceShptLine; "Service Item No.")
            { }
            column(SP; SP)
            { }
            column(TUV; TUV)
            { }
            column(TypeInt; TypeInt)
            {
            }
            column(UnitOfMeasure; UnitOfMeasure)
            { }
            column(Shipment_date; "Shipment date")
            { }

        }
        addafter(DimensionLoop2)
        {
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                column(Entry_No_; TempItemLedEntry."Entry No.") { }
                column(Quantity; TempItemLedEntry.Quantity) { }
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
        modify("Service Shipment Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                ServShipHdr: Record "Service Shipment Header";
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
            begin
                TypeInt := Type.AsInteger();
                if ServiceItem.Get("Service Shipment Line"."Service Item No.") then begin
                    ItemNo := ServiceItem."No.";
                    SerialNo := ServiceItem."Serial No.";
                    PlateNo := ServiceItem."Plate No.";
                    Brand := ServiceItem.Brand;
                    Model := ServiceItem.Model;
                    RegDate := ServiceItem."Reg. Date";
                    KM := ServiceItem."KM-Status";
                    SP := ServiceItem.SP;
                    TUV := ServiceItem."TÜV";
                end;
                if ServShipHdr.Get("Document No.") and (ServShipHdr."Order No." = '') then
                    "Service Item No." := '1';
                TempItemLedEntry.DeleteAll();
                ItemTrackingDoc.RetrieveEntriesFromShptRcpt(TempItemLedEntry, DATABASE::"Service Shipment Line", 0, "Document No.", '', 0, "Line No.");
                if "Unit of Measure Code" = '' then
                    UnitOfMeasure := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure := UnitOfMeasureRec.Description;
                    if ServShipHdr."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", ServShipHdr."Language Code");
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
        modify("Service Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                CompanyInfo: Record "Company Information";
                CountryRec: Record "Country/Region";
                GeneralLedgerSetup: Record "General Ledger Setup";
                PaymentTermsRec: Record "Payment Terms";
                RespCenter: Record "Responsibility Center";
                FormatAddr: Codeunit "Format Address";
                i: Integer;
            begin
                clear(DescriptionVar);
                clear(ShowEngImage);
                clear(ShowDEImage);
                Clear(CompanyAdd);
                Clear(PrintBool);
                Clear(OrderNoText2);
                clear(DescriptionVar);
                clear(ShowEngImage);
                clear(ShowDEImage);
                if not PaymentTermsRec.Get("Payment Terms Code") then
                    PaymentTermsRec.Init();
                CompanyInfo.Get();
                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddress);
                for i := 1 to ArrayLen(CompanyAddress) do begin
                    if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                        CompanyAdd := CompanyAddress[i]
                    else
                        if CompanyAddress[i] <> '' then
                            CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
                end;
                if "Order No." = '' then
                    PrintBool := false
                else
                    PrintBool := true;
                if "Contract No." <> '' then
                    "Order No." := "Contract No.";
                if "Contract No." = '' then
                    OrderNoText2 := FormatDocument1.SetText("Order No." <> '', FieldCaption("Order No."))
                else
                    OrderNoText2 := FormatDocument1.SetText("Contract No." <> '', FieldCaption("Contract No."));
                if GeneralLedgerSetup.Get() then
                    CurrencySymbol := GeneralLedgerSetup."Local Currency Symbol";
                //B2BDNROn10May2023>>
                if "Service Shipment Header"."Language Code" <> '' then
                    if languageCodevar.Get("Service Shipment Header"."Language Code") then begin
                        if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                            DescriptionVar := PaymentTermsRec."English Description";
                            ShowEngImage := true;
                            ShowDEImage := false;
                        end;
                    end else begin
                        DescriptionVar := PaymentTermsRec.Description;
                        ShowEngImage := false;
                        ShowDEImage := true;
                    end
                else begin
                    languageCodevar.Reset();
                    languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                    if languageCodevar.FindFirst() then
                        if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                            DescriptionVar := PaymentTermsRec."English Description";
                            ShowEngImage := true;
                            ShowDEImage := false;
                        end
                        else begin
                            DescriptionVar := PaymentTermsRec.Description;
                            ShowEngImage := false;
                            ShowDEImage := true;
                        end;
                end;
                FormatAddr.ServiceShptShipTo(ShipToAddress, "Service Shipment Header");
                FormatAddr.ServiceShptBillTo(CustAddress, ShipToAddress, "Service Shipment Header");

                //B2BDNROn10May2023<<
            end;
        }
    }
    rendering
    {
        layout(CustomLayout)
        {
            LayoutFile = 'Report Ext\Layouts\Service Shipment.rdl';
            Type = RDLC;
        }
    }
    var
        TempItemLedEntry: Record "Item Ledger Entry" temporary;
        languageCodevar: Record Language;
        ServiceItem: Record "Service Item";
        FormatDocument1: codeunit "Format Document";
        OK: Boolean;
        PrintBool: Boolean;
        ShowDeImage: Boolean;
        ShowEngImage: Boolean;
        ShowShippingAddr1: Boolean;
        ItemNo: Code[20];
        PlateNo: Code[20];
        SerialNo: Code[20];
        RegDate: Date;
        SP: Date;
        TUV: Date;
        KM: Integer;
        TypeInt: Integer;
        AmountCap: Label 'Amount';
        AmountCapLbl: Label 'Line Amount excl. VAT';
        BrandCapLbl: Label 'Brand';
        ContractNoLbl: Label 'Contract No.';
        CustomerReference: Label 'Reference';
        DeliveryAddCap: Label 'Delivery Address';
        KmCapLbl: Label 'Mileage(km)';
        LineCapLbl: Label 'Line discount %';
        ModelCapLbl: Label 'Model';
        PaymentTermCap: Label 'Payment Term';
        QtyCapLbl: Label 'Qty.';
        RegCapLbl: Label 'Reg. Plate No.';
        RegDateCapLbl: Label 'Reg. Date';
        SerialNoCap: Label 'Serial No.';
        SerialNoCapLbl: Label 'VIN';
        ServiceCapLbl: Label 'Service Item';
        ShipmentDateCap: Label 'Shipment Date';
        ShiptoaddCapLbl: Label 'Ship-to address:';
        SPCapLbl: Label 'SP';
        TotalExclVatCap: Label 'Total excl.VAT';
        TotalInclVatCap: Label 'Total incl.VAT';
        TUVCapLbl: Label 'TUV';
        UnitCap: Label 'Unit';
        UnitPriceCapLbl: Label 'Unit price excl. VAT';
        UnitProceCap: Label 'Unit Price';
        VatAmountCap: Label 'VAT Amount';
        OrderNoText2: Text;
        CurrencySymbol: Text[10];
        Brand: Text[20];
        Model: Text[20];
        UnitOfMeasure: Text[50];
        ContractNoText: Text[80];
        CompanyAddress: array[8] of Text[100];
        Companyadress: array[8] of Text[100];
        CustAddress: array[8] of Text[100];
        Customeradress: array[8] of Text[100];
        ShipToAddress: array[8] of Text[100];
        DescriptionVar: Text[250];
        CompanyAdd: Text[500];
        ServiceordertypeCap: Label 'Service Order Type';
        AsignedUserIDCap: label 'Assigned User ID';
        OrderOpendateCap: Label 'Open Date';
        StartDateCap: Label 'Start Date';
        InvoiceDateCap: Label 'Invoice Date';
        OrderNumberCao: Label 'Order No.';
        DiscountCap: Label 'Discount %';
        DeliveryConditionCap: Label 'Delivery Condition';
        CustomerNoCapLbl: Label 'Customer Number';
        ServiceInvoiceHeaderDueDateCaption: Label 'Due Date';
        QtyInvoicedCap: Label 'Qty. Invoiced';
        QtyConsumedCap: Label 'Qty. Consumed';
        PageCap: label 'Page';

}
