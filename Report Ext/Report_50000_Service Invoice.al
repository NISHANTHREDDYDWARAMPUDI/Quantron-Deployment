reportextension 50004 "Service Invoice" extends "Service - Invoice"
{
    dataset
    {
        add("Service Invoice Header")
        {
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(Name; "Ship-to Name")
            { }
            column(Address; "Ship-to Address")
            { }
            column(Address_2; "Ship-to Address 2")
            { }
            column(City; "Ship-to City")
            { }
            column(Post_Code; "Ship-to Post Code")
            { }
            column(Country_Region_Code; "Ship-to Country/Region Code")
            { }
            column(Contact; "Ship-to Contact")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Due_Date; "Due Date")
            { }
            column(ShiptoaddCapLbl; ShiptoaddCapLbl)
            {
            }
            column(CustomerNoCapLbl; CustomerNoCapLbl)
            { }
            column(UnitPriceCapLbl; UnitPriceCapLbl)
            { }
            column(LineCapLbl; LineCapLbl)
            { }
            column(AmountCapLbl; AmountCapLbl)
            { }
            column(Customer_No_; "Customer No.")
            { }
            column(QtyCapLbl; QtyCapLbl)
            { }
            column(PrintBool; PrintBool)
            { }
            column(ContractNoText; ContractNoText)
            { }
            column(CustomerReference; CustomerReference)
            {
            }
            column(DeliveryAddCap; DeliveryAddCap)
            { }
            column(PaymentTermCap; PaymentTermCap)
            { }
            column(UnitCap; UnitCap)
            { }
            column(UnitProceCap; UnitProceCap)
            { }
            column(AmountCap; AmountCap)
            { }
            column(TotalExclVatCap; TotalExclVatCap)
            { }
            column(TotalInclVatCap; TotalInclVatCap)
            { }
            column(VatAmountCap; VatAmountCap)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(CurrencySymbol; CurrencySymbol)
            { }
            //B2BDNROn10May2023>>
            column(ShowEngImage; ShowEngImage)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(ShipToAddress1; ShipToAddress[1])
            { }
            column(ShipToAddress2; ShipToAddress[2])
            { }
            column(ShipToAddress3; ShipToAddress[3])
            { }
            column(ShipToAddress4; ShipToAddress[4])
            { }
            column(ShipToAddress5; ShipToAddress[5])
            { }
            column(ShipToAddress6; ShipToAddress[6])
            { }
            column(ShipToAddress7; ShipToAddress[7])
            { }
            column(ShipToAddress8; ShipToAddress[8])
            {
            }
            column(PageCap; PageCap)
            { }
            column(Service_Order_Type; "Service Order Type")
            { }
            column(DescriptionVar; DescriptionVar)
            { }
            column(User_ID; "User ID")
            { }
            column(Starting_Date; "Starting Date")
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
            column(Order_No_; "Order No.")
            { }
            column(BottomText1; BottomText1)
            { }
            column(Document_Date; "Document Date")
            { }
            column(VAT_Registration_No_; "VAT Registration No.")
            { }
            //B2BDNROn10May2023<<
            column(TotalLineAmount1; TotalLineAmount1)
            { }
            column(TotalAmountInclVAT1; TotalAmountInclVAT1)
            { }
            column(TotalAmount1; TotalAmount1)
            { }

        }
        add(PageLoop)
        {
            column(ServiceCapLbl; ServiceCapLbl)
            { }
            column(SerialNoCapLbl; SerialNoCapLbl)
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            column(RegCapLbl; RegCapLbl)
            { }
            column(BrandCapLbl; BrandCapLbl)
            { }
            column(ModelCapLbl; ModelCapLbl)
            { }
            column(TUVCapLbl; TUVCapLbl)
            { }
            column(RegDateCapLbl; RegDateCapLbl)
            { }
            column(KmCapLbl; KmCapLbl)
            { }
            column(SPCapLbl; SPCapLbl)
            { }
            column(CustomerNoCap; CustomerNoCapLbl)
            { }
            column(OrderNoText2; OrderNoText2)
            { }
            column(ShipmentDateCap; ShipmentDateCap)
            { }
        }
        add("Service Invoice Line")
        {
            column(ServiceItemNo_ServiceInvoiceLine; "Service Item No.")
            {
            }
            column(ItemNo; ItemNo)
            { }
            column(SerialNo; SerialNo)
            { }
            column(PlateNo; PlateNo)
            { }
            column(Brand; Brand)
            { }
            column(Model; Model)
            { }
            column(TUV; TUV)
            { }
            column(RegDate; RegDate)
            { }
            column(KM; KM)
            { }
            column(SP; SP)
            { }
            column(ShipmentDate; "Shipment Date")
            { }
            column(UnitOfMeasure; UnitOfMeasure)
            { }
            Column(Line_Discount__; "Line Discount %")
            { }


        }
        addafter(DimensionLoop2)
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
        modify("Service Invoice Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                ServInvHdr: Record "Service Invoice Header";
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
            begin
                //QTD-00006>>
                // if not ShowAllResource then
                //     if ("Service Invoice Line".Type = "Service Invoice Line".TYPE::Resource) AND (not "Service Invoice Line"."Print On Order") then
                //         CurrReport.Skip();
                TotalLineAmount1 += "Line Amount";
                TotalAmountInclVAT1 += "Amount Including VAT";
                TotalAmount1 += Amount;

                //QTD-00006>>
                if ServiceItem.Get("Service Invoice Line"."Service Item No.") then begin
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
                if ServInvHdr.Get("Document No.") and (ServInvHdr."Order No." = '') then
                    "Service Item No." := '1';
                TempItemLedEntry.DeleteAll();
                ItemTrackingDoc.RetrieveEntriesFromPostedInvoice(TempItemLedEntry, "Service Invoice Line".RowID1());

                if "Unit of Measure Code" = '' then
                    UnitOfMeasure := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure := UnitOfMeasureRec.Description;
                    if ServInvHdr."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", ServInvHdr."Language Code");
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
        modify("Service Invoice Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                RespCenter: Record "Responsibility Center";
                FormatAddr: Codeunit "Format Address";
                CompanyInfo: Record "Company Information";
                i: Integer;
                GeneralLedgerSetup: Record "General Ledger Setup";
                CountryRec: Record "Country/Region";
                PaymentTerms: Record "Payment Terms";
            begin
                clear(DescriptionVar);
                clear(ShowEngImage);
                clear(ShowDEImage);
                clear(TotalLineAmount1);
                clear(TotalAmountInclVAT1);
                clear(TotalAmount1);

                if not PaymentTerms.Get("Payment Terms Code") then
                    PaymentTerms.Init();
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
                if "Service Invoice Header"."Language Code" <> '' then
                    if languageCodevar.Get("Service Invoice Header"."Language Code") then begin
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
                FormatAddr.GetCompanyAddr("Service Invoice Header"."Responsibility Center", RespCenter, CompanyInfo, CompanyAdress);
                FormatAddr.ServiceInvBillTo(CustomerAdress, "Service Invoice Header");
                ShowShippingAddr1 := FormatAddr.ServiceInvShipTo(ShipToAddress, CustomerAdress, "Service Invoice Header");

                //B2BDNROn10May2023<<
            end;
        }

    }

    requestpage
    {
        // Add changes to the requestpage here
        layout
        {
            addafter(DisplayAdditionalFeeNote)
            {
                // field(ShowAllResource; ShowAllResource)
                // {
                //     Caption = 'Show all resources';
                //     ApplicationArea = all;
                // }
            }
        }
    }

    rendering
    {
        layout(CustomLayout)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Service Invoice.rdl';
        }
    }


    trigger OnPreReport()
    var

        FormatAddr: Codeunit "Format Address";
        RespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        i: Integer;
    begin
        Clear(CompanyAdd);
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
        TempItemLedEntry: Record "Item Ledger Entry" temporary;
        OK: Boolean;
        ServiceItem: Record "Service Item";
        ServiceCapLbl: Label 'Service Item';
        SerialNoCapLbl: Label 'VIN';
        SerialNoCap: Label 'Serial No.';
        RegCapLbl: Label 'Reg. Plate No.';
        BrandCapLbl: Label 'Brand';
        ModelCapLbl: Label 'Model';
        TUVCapLbl: Label 'TUV';
        RegDateCapLbl: Label 'Reg. Date';
        KmCapLbl: Label 'Mileage(km)';
        SPCapLbl: Label 'SP';
        CustomerNoCapLbl: Label 'Customer Number';
        ShiptoaddCapLbl: Label 'Ship-to address:';
        ItemNo: Code[20];
        SerialNo: Code[20];
        PlateNo: Code[20];
        Brand: Text[20];
        Model: Text[20];
        TUV: Date;
        RegDate: Date;
        KM: Integer;
        SP: Date;
        UnitPriceCapLbl: Label 'Unit price excl. VAT';
        LineCapLbl: Label 'Line discount %';
        AmountCapLbl: Label 'Line Amount excl. VAT';
        QtyCapLbl: Label 'Qty.';
        PrintBool: Boolean;
        ContractNoLbl: Label 'Contract No.';
        CustomerReference: Label 'Reference';
        ContractNoText: Text[80];
        OrderNoText2: Text;
        CompanyAdd: Text[500];
        CompanyAddress: array[8] of Text[100];
        FormatDocument1: codeunit "Format Document";
        DeliveryAddCap: Label 'Delivery Address';
        PaymentTermCap: Label 'Payment Term';
        TotalExclVatCap: Label 'Total excl.VAT';
        VatAmountCap: Label 'VAT Amount';
        TotalInclVatCap: Label 'Total incl.VAT';
        UnitCap: Label 'Unit';
        UnitProceCap: Label 'Unit Price';
        AmountCap: Label 'Amount';
        ShipmentDateCap: Label 'Shipment Date';
        CurrencySymbol: Text[10];
        ShowEngImage: Boolean;
        ShowDeImage: Boolean;
        languageCodevar: Record Language;
        ShipToAddress: array[8] of Text[100];
        Companyadress: array[8] of Text[100];
        Customeradress: array[8] of Text[100];
        ShowShippingAddr1: Boolean;
        UnitOfMeasure: Text[50];
        DescriptionVar: Text[200];
        ServiceordertypeCap: Label 'Service Order Type';
        AsignedUserIDCap: label 'Assigned User ID';
        OrderOpendateCap: Label 'Order Open Date';
        StartDateCap: Label 'Start Date';
        InvoiceDateCap: Label 'Invoice Date';
        OrderNumberCao: Label 'Order No.';
        DiscountCap: Label 'Discount %';
        TotalLineAmount1: Decimal;
        TotalAmountInclVAT1: Decimal;
        TotalAmount1: Decimal;
        PageCap: label 'Page';
        BottomText1: label 'Tax Note: No VAT liability in Sellerss Country under Articles 44 of EC Directive 2006/12.Customer to reverse charge in Buyers Country under Article 196. Intra-Community delivery.';
    //ShowAllResource: Boolean;


}
