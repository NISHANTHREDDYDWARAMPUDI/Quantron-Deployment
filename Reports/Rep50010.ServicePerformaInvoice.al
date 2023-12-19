report 50010 ServicePerformaInvoice
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Service Proforma Invoice';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\ServiceProformaInvoice.rdl';

    dataset
    {
        dataitem("Service Header"; "Service Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Customer No.";
            column(No_ServHeader; "No.")
            {
            }
            column(No_ServHeaderCaption; FieldCaption("No."))
            {
            }
            column(DiscountCap; DiscountCap)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(DuedateCap; DuedateCap)
            { }
            column(AmountCap; AmountCap)
            { }
            column(Shipment_date; "Shipment date")
            { }
            column(CustomerReference; CustomerReference)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(BottomText1; BottomText1)
            { }
            column(DescriptionVar; DescriptionVar)
            { }
            column(CurrencySymbol; CurrencySymbol)
            { }
            column(TotalExclVatCap; TotalExclVatCap)
            {
            }
            column(TotalInclVatCap; TotalInclVatCap)
            {
            }
            column(VatAmountCap; VatAmountCap)
            {
            }
            column(ShipmentDatecap; ShipmentDatecap)
            { }
            column(PaymenttermCap; PaymenttermCap)
            { }
            column(TermsofdeliveryCap; TermsofdeliveryCap)
            { }
            column(OrderdateCap; OrderdateCap)
            { }
            column(StartdateCap; StartdateCap)
            { }
            column(EnddateCap; EnddateCap)
            { }
            column(ServiceOrderTypeCap; ServiceOrderTypeCap)
            { }
            column(OrderOpendateCap; OrderOpendateCap)
            { }
            column(AssignedUserCap; AssignedUserCap)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(QtyCap; QtyCap)
            { }
            column(Customer_No_; "Customer No.")
            { }
            column(Document_Date; "Document Date")
            { }
            column(CustomerNoCapLbl; CustomerNoCapLbl)
            { }
            column(Starting_Date; "Starting Date")
            { }
            column(Due_Date; "Due Date")
            { }
            column(UnitCap; UnitCap)
            { }
            column(ItemnoCap; ItemnoCap)
            { }
            column(DescriptionCap1; DescriptionCap1)
            { }
            column(DescriptionCap2; DescriptionCap2)
            { }
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
            column(UnitProceCap; UnitProceCap)
            { }
            column(ServiceOrderCap; StrSubstNo(ServiceOrderCap, CopyText1))
            { }
            column(SPCapLbl; SPCapLbl)
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(PageCap; PageCap)
            { }
            column(ItemserialNoCap; ItemserialNoCap)
            { }
            column(ShipToaddCap; ShipToaddCap)
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
            { }
            column(Service_Order_Type; "Service Order Type")
            { }
            column(Assigned_User_ID; "Assigned User ID")
            { }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(ContractNo_ServHeader; "Service Header"."Contract No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(OrderTime_ServHeader; "Service Header"."Order Time")
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    Column(CustAddr7; CustAddr[7])
                    { }
                    Column(CustAddr8; CustAddr[8])
                    { }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(OrderDate_ServHeader; Format("Service Header"."Order Date"))
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(Status_ServHeader; "Service Header".Status)
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(BilltoName_ServHeader; "Service Header"."Bill-to Name")
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(ServOrderCopyText; StrSubstNo(Text001, Format("Service Header"."No.")))
                    {
                    }
                    Column(CustomerCaption; strsubstno(CustomerCaptionLbl, "Service Header"."Customer No."))
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    {
                    }
                    column(PhoneNo_ServHeader; "Service Header"."Phone No.")
                    {
                    }
                    column(Email_ServHeader; "Service Header"."E-Mail")
                    {
                    }
                    column(Description_ServHeader; "Service Header".Description)
                    {
                    }
                    column(PageCaption; StrSubstNo(Text002, ' '))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ContractNoCaption; ContractNoCaptionLbl)
                    {
                    }
                    column(ServiceHeaderOrderDateCaption; ServiceHeaderOrderDateCaptionLbl)
                    {
                    }
                    column(InvoicetoCaption; InvoicetoCaptionLbl)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoFaxNoCaption; CompanyInfoFaxNoCaptionLbl)
                    {
                    }
                    column(ServiceHeaderEMailCaption; ServiceHeaderEMailCaptionLbl)
                    {
                    }
                    column(OrderTime_ServHeaderCaption; "Service Header".FieldCaption("Order Time"))
                    {
                    }
                    column(Status_ServHeaderCaption; "Service Header".FieldCaption(Status))
                    {
                    }
                    column(Description_ServHeaderCaption; "Service Header".FieldCaption(Description))
                    {
                    }
                    Column(AssignedUser_ServiceHeader; "Service Header"."Assigned User ID")
                    {
                    }
                    column(AssignedUserCaption_ServiceHeader; "Service Header".FieldCaption("Assigned User ID"))
                    {
                    }
                    column(ServiceOrderType_ServiceHeader; "Service Header"."Service Order Type")
                    {
                    }
                    column(ServiceOrderTypeCaption_ServiceHeader; "Service Header".FieldCaption("Service Order Type"))
                    {
                    }
                    column(ServiceOrderDate_ServiceHeader; "Service Header"."Order Date")
                    {
                    }
                    column(ServiceOrderDateCaption_ServiceHeader; "Service Header".FieldCaption("Order Date"))
                    {
                    }
                    column(ServiceOrderStartDate_ServiceHeader; "Service Header"."Starting Date")
                    {
                    }
                    column(ServiceOrderStartDateCaption_ServiceHeader; "Service Header".FieldCaption("Starting Date"))
                    {
                    }
                    column(ServiceOrderFinishDate_ServiceHeader; "Service Header"."Finishing Date")
                    {
                    }
                    column(ServiceOrderFinishDateCaption_ServiceHeader; "Service Header".FieldCaption("Finishing Date"))
                    {
                    }
                    column(SLCommentExists; SLCommentExists)
                    {
                    }
                    column(SLItemExists; SLItemExists)
                    {
                    }
                    column(SLResourceExists; SLResourceExists)
                    {
                    }
                    dataitem("Service Item Line"; "Service Item Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Service Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                        column(LineNo_ServItemLine; "Line No.")
                        {
                        }
                        column(SerialNo_ServItemLine; "Serial No.")
                        {
                        }
                        column(Description_ServItemLine; Description)
                        {
                        }
                        column(ItemNo_ServItemLineServ; "Service Item No.")
                        {
                        }
                        column(ServItemGroupCode_ServItemLine; "Service Item Group Code")
                        {
                        }
                        column(Warranty_ServItemLine; Format(Warranty))
                        {
                        }
                        column(LoanerNo_ServItemLine; "Loaner No.")
                        {
                        }
                        column(RepairStatusCode_ServItemLine; "Repair Status Code")
                        {
                        }
                        column(ServShelfNo_ServItemLine; "Service Shelf No.")
                        {
                        }
                        column(ResponseTime_ServItemLine; Format("Response Time"))
                        {
                        }
                        column(ResponseDate_ServItemLine; Format("Response Date"))
                        {
                        }
                        column(DocumentNo_ServItemLine; "Document No.")
                        {
                        }
                        column(ServiceItemLineWarrantyCaption; CaptionClassTranslate(FieldCaption(Warranty)))
                        {
                        }
                        column(ServiceItemLinesCaption; ServiceItemLinesCaptionLbl)
                        {
                        }
                        column(ServiceItemLineResponseDateCaption; ServiceItemLineResponseDateCaptionLbl)
                        {
                        }
                        column(ServiceItemLineResponseTimeCaption; ServiceItemLineResponseTimeCaptionLbl)
                        {
                        }
                        column(SerialNo_ServItemLineCaption; FieldCaption("Serial No."))
                        {
                        }
                        column(Description_ServItemLineCaption; FieldCaption(Description))
                        {
                        }
                        column(ItemNo_ServItemLineServCaption; FieldCaption("Service Item No."))
                        {
                        }
                        column(ServItemGroupCode_ServItemLineCaption; FieldCaption("Service Item Group Code"))
                        {
                        }
                        column(LoanerNo_ServItemLineCaption; FieldCaption("Loaner No."))
                        {
                        }
                        column(RepairStatusCode_ServItemLineCaption; FieldCaption("Repair Status Code"))
                        {
                        }
                        column(ServShelfNo_ServItemLineCaption; FieldCaption("Service Shelf No."))
                        {
                        }
                        column(ServItem_SerialNo; ServiceItem_g."Serial No.")
                        {
                        }
                        column(ServItem_SerialNo_Caption; ServiceItem_g.FieldCaption("Serial No."))
                        {
                        }
                        column(ServItem_RegistrationDate; ServiceItem_g."Reg. Date")
                        {
                        }
                        column(ServItem_RegistrationDate_Caption; ServiceItem_g.FieldCaption("Reg. Date"))
                        {
                        }
                        column(ServItem_TUEV; ServiceItem_g."TÜV")
                        {
                        }
                        column(ServItem_TUEV_Caption; ServiceItem_g.FieldCaption("TÜV"))
                        {
                        }
                        column(ServItem_Brand; ServiceItem_g.Brand)
                        {
                        }
                        column(ServItem_Brand_Caption; ServiceItem_g.FieldCaption(Brand))
                        {
                        }
                        column(ServItem_PlatNo; ServiceItem_g."Plate No.")
                        {
                        }
                        column(ServItem_PlateNo_Caption; ServiceItem_g.FieldCaption("Plate No."))
                        {
                        }
                        column(ServItem_Mileage; ServiceItem_g."KM-Status")
                        {
                        }
                        column(ServItem_Mileage_Caption; ServiceItem_g.FieldCaption("KM-Status"))
                        {
                        }
                        column(ServItem_SP; ServiceItem_g.SP)
                        {
                        }
                        column(ServItem_SP_Caption; ServiceItem_g.FieldCaption(SP))
                        {
                        }
                        column(ServItem_Model; ServiceItem_g.Model)
                        {
                        }
                        column(ServItem_Model_Caption; ServiceItem_g.FieldCaption(Model))
                        {
                        }
                        column(Service_Item_No_; "Service Item No.")
                        { }
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
                        dataitem("Service Line Comment"; "Service Line")
                        {
                            DataItemLinkReference = "Service Item Line";
                            DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Service Item Line No." = Field("Line No.");
                            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") where(Type = filter(''));
                            column(ServLineCommentLineNo; "Line No.")
                            {
                            }
                            column(ServLineCommentTotalAmt; TotalAmt)
                            {
                            }
                            column(ServLineCommentTotalGrossAmt; TotalGrossAmt)
                            {
                            }
                            column(ServItemSerialNo_ServLineComment; "Service Item Serial No.")
                            {
                            }
                            column(Type_ServLineComment; Type)
                            {
                            }
                            column(No_ServLineComment; "No.")
                            {
                            }
                            column(VariantCode_ServLineComment; "Variant Code")
                            {
                            }
                            column(Description_ServLineComment; Description)
                            {
                            }
                            column(Qty_ServLineComment; Qty)
                            {
                            }
                            column(UnitPrice_ServLineComment; "Unit Price")
                            {
                            }
                            column(LineDiscount_ServLineComment; "Line Discount %")
                            {
                            }
                            column(Amt_ServLineComment; Amt)
                            {
                            }
                            column(GrossAmt_ServLineComment; GrossAmt)
                            {
                            }
                            column(QtyConsumed_ServLineComment; "Quantity Consumed")
                            {
                            }
                            column(QtytoConsume_ServLineComment; "Qty. to Consume")
                            {
                            }
                            column(DocumentNo_ServLineComment; "Document No.")
                            {
                            }
                            column(QtyCaption_ServLineComment; QtyCaptionLbl)
                            {
                            }
                            column(ServiceLinesCaption_ServLineComment; ServiceLinesCaptionLbl)
                            {
                            }
                            column(AmountCaption_ServLineComment; AmountCaptionLbl)
                            {
                            }
                            column(GrossAmountCaption_ServLineComment; GrossAmountCaptionLbl)
                            {
                            }
                            column(TotalCaption_ServLineComment; TotalCaptionLbl)
                            {
                            }
                            column(ServItemSerialNo_ServLineCommentCaption; FieldCaption("Service Item Serial No."))
                            {
                            }
                            column(Type_ServLineCommentCaption; FieldCaption(Type))
                            {
                            }
                            column(No_ServLineCommentCaption; FieldCaption("No."))
                            {
                            }
                            column(VariantCode_ServLineCommentCaption; FieldCaption("Variant Code"))
                            {
                            }
                            column(Description_ServLineCommentCaption; FieldCaption(Description))
                            {
                            }
                            column(UnitPrice_ServLineCommentCaption; FieldCaption("Unit Price"))
                            {
                            }
                            column(LineDiscount_ServLineCommentCaption; FieldCaption("Line Discount %"))
                            {
                            }
                            column(QtyConsumed_ServLineCommentCaption; FieldCaption("Quantity Consumed"))
                            {
                            }
                            column(QtytoConsume_ServLineCommentCaption; FieldCaption("Qty. to Consume"))
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if ShowQty = ShowQty::Quantity then begin
                                    Qty := Quantity;
                                    Amt := "Line Amount";
                                    GrossAmt := "Amount Including VAT";
                                end else begin
                                    if "Quantity Invoiced" = 0 then
                                        CurrReport.Skip();
                                    Qty := "Quantity Invoiced";

                                    Amt := Round((Qty * "Unit Price") * (1 - "Line Discount %" / 100));
                                    GrossAmt := (1 + "VAT %" / 100) * Amt;
                                end;

                                TotalAmt += Amt;
                                TotalGrossAmt += GrossAmt;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(Amt);
                                Clear(GrossAmt);

                                TotalAmt := 0;
                                TotalGrossAmt := 0;
                            end;

                        }
                        dataitem("Service Line Item"; "Service Line")
                        {
                            DataItemLinkReference = "Service Item Line";
                            DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Service Item Line No." = Field("Line No.");
                            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") where(Type = filter(Item));
                            column(ServLineItemLineNo; "Line No.")
                            {
                            }
                            column(ServLineItem_TotalAmt; TotalAmt)
                            {
                            }
                            column(VATAmountLineVAT; "VAT %")
                            { }
                            column(ServLineItem_TotalGrossAmt; TotalGrossAmt)
                            {
                            }
                            column(TotalLineAmount; "Line Amount")
                            { }
                            column(TotalAmountInclVAT; "Amount Including VAT")
                            { }
                            column(TotalAmount; Amount)
                            { }
                            column(ServItemSerialNo_ServLineItem; "Service Item Serial No.")
                            {
                            }
                            column(Type_ServLineItem; Type)
                            {
                            }
                            column(No_ServLineItem; "No.")
                            {
                            }
                            column(VariantCode_ServLineItem; "Variant Code")
                            {
                            }
                            column(Description_ServLineItem; Description)
                            {
                            }
                            column(Qty_ServLineItem; Qty)
                            {
                            }
                            column(UOM_ServLineItem; "Unit of Measure")
                            {
                            }
                            column(UnitPrice_ServLineItem; "Unit Price")
                            {
                            }
                            column(LineDiscount_ServLineItem; "Line Discount %")
                            {
                            }
                            column(Amt_ServLineItem; Amt)
                            {
                            }
                            column(GrossAmt_ServLineItem; GrossAmt)
                            {
                            }
                            column(QtyConsumed_ServLineItem; "Quantity Consumed")
                            {
                            }
                            column(QtytoConsume_ServLineItem; "Qty. to Consume")
                            {
                            }
                            column(DocumentNo_ServLineItem; "Document No.")
                            {
                            }
                            column(QtyCaption_ServLineItem; QtyCaptionLbl)
                            {
                            }
                            column(ServiceLinesCaption_ServLineItem; ServiceLinesCaptionLbl)
                            {
                            }
                            column(AmountCaption_ServLineItem; AmountCaptionLbl)
                            {
                            }
                            column(GrossAmountCaption_ServLineItem; GrossAmountCaptionLbl)
                            {
                            }
                            column(TotalCaption_ServLineItem; TotalCaptionLbl)
                            {
                            }
                            column(ServItemSerialNo_ServLineItemCaption; FieldCaption("Service Item Serial No."))
                            {
                            }
                            column(Type_ServLineItemCaption; FieldCaption(Type))
                            {
                            }
                            column(No_ServLineItemCaption; FieldCaption("No."))
                            {
                            }
                            column(VariantCode_ServLineItemCaption; FieldCaption("Variant Code"))
                            {
                            }
                            column(Description_ServLineItemCaption; FieldCaption(Description))
                            {
                            }
                            column(UnitPrice_ServLineItemCaption; FieldCaption("Unit Price"))
                            {
                            }
                            column(LineDiscount_ServLineItemCaption; FieldCaption("Line Discount %"))
                            {
                            }
                            column(QtyConsumed_ServLineItemCaption; FieldCaption("Quantity Consumed"))
                            {
                            }
                            column(QtytoConsume_ServLineItemCaption; FieldCaption("Qty. to Consume"))
                            {
                            }

                            column(UnitOfMeasure1; UnitOfMeasure1)
                            { }
                            column(Description2; Description2)
                            { }
                            column(UnitPrice_ServInvLine; "Unit Price")
                            {
                            }
                            column(LineAmt_ServInvLine; "Line Amount")
                            {
                            }
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
                            trigger OnAfterGetRecord()
                            var
                                UnitOfMeasureRec: Record "Unit of Measure";
                                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                                ItemLRec: Record Item;
                                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
                            begin
                                if ShowQty = ShowQty::Quantity then begin
                                    Qty := Quantity;
                                    Amt := "Line Amount";
                                    GrossAmt := "Amount Including VAT";
                                end else begin
                                    if "Quantity Invoiced" = 0 then
                                        CurrReport.Skip();
                                    Qty := "Quantity Invoiced";

                                    Amt := Round((Qty * "Unit Price") * (1 - "Line Discount %" / 100));
                                    GrossAmt := (1 + "VAT %" / 100) * Amt;
                                end;

                                TotalAmt += Amt;
                                TotalGrossAmt += GrossAmt;
                                if "Unit of Measure Code" = '' then
                                    UnitOfMeasure1 := ''
                                else begin
                                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                                        UnitOfMeasureRec.Init();
                                    UnitOfMeasure := UnitOfMeasureRec.Description;
                                    if "Service Header"."Language Code" <> '' then begin
                                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                                        UnitOfMeasureTranslation.SetRange("Language Code", "Service Header"."Language Code");
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
                                TempTrackingSpecBuffer.DeleteAll();
                                If ItemLRec.Get("No.") then begin
                                    Description2 := ItemLRec."Description 2";
                                    if ItemLRec."Item Tracking Code" <> '' then
                                        ItemTrackingDoc.FindReservEntries(TempTrackingSpecBuffer, Database::"Service Line", 1, "Document No.", '', 0, "Line No.", '');
                                end;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(Amt);
                                Clear(GrossAmt);

                                TotalAmt := 0;
                                TotalGrossAmt := 0;
                            end;
                        }

                        dataitem("Service Line Resource"; "Service Line")
                        {
                            DataItemLinkReference = "Service Item Line";
                            DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Service Item Line No." = Field("Line No.");
                            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") where(Type = filter(Resource));

                            column(ServLineResourceLineNo; "Line No.")
                            {
                            }
                            column(TotalAmt_ServLineResource; TotalAmt)
                            {
                            }
                            column(TotalGrossAmt_ServLineResource; TotalGrossAmt)
                            {
                            }
                            column(ServItemSerialNo_ServLineResource; "Service Item Serial No.")
                            {
                            }
                            column(Type_ServLineResource; Type)
                            {
                            }
                            column(No_ServLineResource; "No.")
                            {
                            }
                            column(VariantCode_ServLineResource; "Variant Code")
                            {
                            }
                            column(Description_ServLineResource; Description)
                            {
                            }
                            column(Qty_ServLineResource; Qty)
                            {
                            }
                            column(UOM_ServLineResource; "Unit of Measure")
                            {
                            }
                            column(UnitPrice_ServLineResource; "Unit Price")
                            {
                            }
                            column(LineDiscount_ServLineResource; "Line Discount %")
                            {
                            }
                            column(Amt_ServLineResource; Amt)
                            {
                            }
                            column(GrossAmt_ServLineResource; GrossAmt)
                            {
                            }
                            column(QtyConsumed_ServLineResource; "Quantity Consumed")
                            {
                            }
                            column(QtytoConsume_ServLineResource; "Qty. to Consume")
                            {
                            }
                            column(DocumentNo_ServLineResource; "Document No.")
                            {
                            }
                            column(QtyCaption_ServLineResource; QtyCaptionLbl)
                            {
                            }
                            column(ServiceLinesResourceCaption; ServiceLinesCaptionLbl)
                            {
                            }
                            column(AmountCaption_ServLineResource; AmountCaptionLbl)
                            {
                            }
                            column(GrossAmountCaption_ServLineResource; GrossAmountCaptionLbl)
                            {
                            }
                            column(TotalCaption_ServLineResource; TotalCaptionLbl)
                            {
                            }
                            column(ServItemSerialNo_ServLineResourceCaption; FieldCaption("Service Item Serial No."))
                            {
                            }
                            column(Type_ServLineResourceCaption; FieldCaption(Type))
                            {
                            }
                            column(No_ServLineResourceCaption; FieldCaption("No."))
                            {
                            }
                            column(VariantCode_ServLineResourceCaption; FieldCaption("Variant Code"))
                            {
                            }
                            column(Description_ServLineResourceCaption; FieldCaption(Description))
                            {
                            }
                            column(UnitPrice_ServLineResourceCaption; FieldCaption("Unit Price"))
                            {
                            }
                            column(LineDiscount_ServLineResourceCaption; FieldCaption("Line Discount %"))
                            {
                            }
                            column(QtyConsumed_ServLineResourceCaption; FieldCaption("Quantity Consumed"))
                            {
                            }
                            column(QtytoConsume_ServLineResourceCaption; FieldCaption("Qty. to Consume"))
                            {
                            }
                            column(LineAmount_ServiceItemResource; "Line Amount")
                            { }
                            column(UnitOfMeasure; UnitOfMeasure)
                            { }

                            trigger OnAfterGetRecord()
                            var
                                UnitOfMeasureRec: Record "Unit of Measure";
                                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                            begin
                                //CHB2B14Nov2023<<
                                // if not "Print On Order" then
                                //     CurrReport.Skip();
                                //CHB2B14Nov2023<<
                                if ShowQty = ShowQty::Quantity then begin
                                    Qty := Quantity;
                                    Amt := "Line Amount";
                                    GrossAmt := "Amount Including VAT";
                                end else begin
                                    if "Quantity Invoiced" = 0 then
                                        CurrReport.Skip();
                                    Qty := "Quantity Invoiced";

                                    Amt := Round((Qty * "Unit Price") * (1 - "Line Discount %" / 100));
                                    GrossAmt := (1 + "VAT %" / 100) * Amt;
                                end;

                                TotalAmt += Amt;
                                TotalGrossAmt += GrossAmt;
                                if "Unit of Measure Code" = '' then
                                    UnitOfMeasure := ''
                                else begin
                                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                                        UnitOfMeasureRec.Init();
                                    UnitOfMeasure := UnitOfMeasureRec.Description;
                                    if "Service Header"."Language Code" <> '' then begin
                                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                                        UnitOfMeasureTranslation.SetRange("Language Code", "Service Header"."Language Code");
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

                            trigger OnPreDataItem()
                            begin
                                Clear(Amt);
                                Clear(GrossAmt);

                                TotalAmt := 0;
                                TotalGrossAmt := 0;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            ServiceItem: Record "Service Item";
                        begin
                            if "Service Item Line"."Service Item No." <> '' then begin
                                if not ServiceItem_g.get("Service Item Line"."Service Item No.") then
                                    ServiceItem_g.init;
                            end else begin
                                ServiceItem_g.init;
                            end;

                            //--Check for Presence of Detail Lines
                            SLCommentExists := false;
                            SLItemExists := false;
                            SLResourceExists := false;

                            TestServiceLine.Reset;
                            TestServiceLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                            TestServiceLine.SetRange("Document Type", "Service Item Line"."Document Type");
                            TestServiceLine.SetRange("Document No.", "Service Item Line"."Document No.");
                            TestServiceLine.SetRange("Service Item Line No.", "Service Item Line"."Line No.");

                            TestServiceLine.SetRange(Type, TestServiceLine.type::" ");
                            if TestServiceLine.FindFirst() then
                                SLCommentExists := True;

                            TestServiceLine.SetRange(type, TestServiceLine.type::Item);
                            if TestServiceLine.FindFirst() then
                                SLItemExists := true;

                            TestServiceLine.SetRange(type, TestServiceLine.Type::Resource);
                            if TestServiceLine.FindFirst() then
                                SLResourceExists := true;
                            //++END Check for Presence of Detail Lines
                            if ServiceItem.Get("Service Item Line"."Service Item No.") then begin
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
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    FormatDocument: Codeunit "Format Document";
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        CopyText1 := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    CopyText1 := '';
                    SetRange(Number, 1, NoOfLoops);

                    OutputNo := 1;

                end;
            }

            trigger OnAfterGetRecord()
            var
                i: Integer;
                PaymentTerms: Record "Payment Terms";
                CompanyInfo: Record "Company Information";
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";

            begin
                clear(DescriptionVar);
                clear(ShowEngImage);
                clear(ShowDEImage);
                Clear(CompanyAdd);
                CurrReport.Language := LanguageRec.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields("Service Header");

                //DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                if GeneralLedgerSetup.Get() then CurrencySymbol := GeneralLedgerSetup."Local Currency Symbol";
                CompanyInfo.Get();
                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddress);
                for i := 1 to ArrayLen(CompanyAddress) do begin
                    if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                        CompanyAdd := CompanyAddress[i]
                    else
                        if CompanyAddress[i] <> '' then
                            CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
                end;
                if PaymentTerms.Get("Payment Terms Code") then begin
                    if "Service Header"."Language Code" <> '' then begin
                        if languageCodevar.Get("Service Header"."Language Code") then begin
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
                        end else begin
                            DescriptionVar := PaymentTerms.Description;
                            ShowEngImage := false;
                            ShowDEImage := true;
                        end;
                    end else begin
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
                    FormatAddr.ServiceOrderShipto(ShipToAddress, "Service Header");
                end;
            end;
        }
    }
    requestpage
    {
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
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Service;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(ShowQty; ShowQty)
                    {
                        ApplicationArea = Service;
                        Caption = 'Amounts Based on';
                        OptionCaption = 'Quantity,Quantity Invoiced';
                        ToolTip = 'Specifies the amounts that the service order is based on.';
                    }
                }
            }
        }
        actions
        {
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        ServiceSetup.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ServiceSetup: Record "Service Mgt. Setup";
        RespCenter: Record "Responsibility Center";
        ServiceItem_g: Record "Service Item";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        Qty: Decimal;
        Amt: Decimal;
        GrossAmt: Decimal;
        TotalAmt: Decimal;
        TotalGrossAmt: Decimal;
        GeneralLedgerSetup: Record "General Ledger Setup";
        LanguageRec: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        ShowInternalInfo: Boolean;
        ShowShippingAddr: Boolean;
        ShowQty: Option Quantity,"Quantity Invoiced";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        CopyText: Text[30];
        Text001: Label 'Service Order %1';
        Text002: Label 'Page %1';
        ContractNoCaptionLbl: Label 'Contract No.';
        ServiceHeaderOrderDateCaptionLbl: Label 'Order Date';
        OrderOpendateCap: Label 'Open Date';
        InvoicetoCaptionLbl: Label 'Invoice to';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoFaxNoCaptionLbl: Label 'Fax No.';
        ServiceHeaderEMailCaptionLbl: Label 'Email';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        ServiceItemLinesCaptionLbl: Label 'Service Item Lines';
        ServiceItemLineResponseDateCaptionLbl: Label 'Response Date';
        ServiceItemLineResponseTimeCaptionLbl: Label 'Response Time';
        FaultCommentsCaptionLbl: Label 'Fault Comments';
        ResolutionCommentsCaptionLbl: Label 'Resolution Comments';
        QtyCaptionLbl: Label 'Quantity';
        ServiceLinesCaptionLbl: Label 'Service Lines';
        AmountCaptionLbl: Label 'Amount';
        GrossAmountCaptionLbl: Label 'Gross Amount';
        TotalCaptionLbl: Label 'Total';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        CustomerCaptionLbl: Label 'Customer (Receiver of Service): %1';
        TestServiceLine: Record "Service Line";
        SLCommentExists: Boolean;
        SLItemExists: Boolean;
        SLResourceExists: Boolean;
        TempTrackingSpecBuffer: Record "Tracking Specification" temporary;
        OK: Boolean;
        DescriptionVar: Text[100];
        ShowEngImage: Boolean;
        ShowDEImage: Boolean;
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        languageCodevar: Record Language;
        ItemNo: Code[20];
        SerialNo: Code[20];
        PlateNo: Code[20];
        Brand: Text[20];
        Model: Text[20];
        TUV: Date;
        RegDate: Date;
        KM: Integer;
        SP: Date;
        CopyText1: Text[30];
        ShipToAddress: array[8] of Text[100];
        ShipToaddCap: Label 'Delivery Address';
        ShipmentDatecap: Label 'Shipment Date';
        PaymenttermCap: Label 'Payment Term';
        TermsofdeliveryCap: Label 'Delivery Condition';
        OrderdateCap: Label 'Order Date';
        StartdateCap: Label 'Start Date';
        EnddateCap: Label 'End Date';
        ServiceOrderTypeCap: Label 'Service Order Type';
        AssignedUserCap: label 'Assigned User ID';
        QtyCap: Label 'Qty';
        UnitCap: Label 'Unit';
        ItemnoCap: Label 'Item No.';
        DescriptionCap1: Label 'Description';
        DescriptionCap2: Label 'Description 2';
        ServiceCapLbl: Label 'Service Item';
        SerialNoCapLbl: Label 'VIN';
        SerialNoCap: Label 'Serial No.';
        RegCapLbl: Label 'Reg. Plate No.';
        BrandCapLbl: Label 'Brand';
        ModelCapLbl: Label 'Model';
        TUVCapLbl: Label 'TUV';
        RegDateCapLbl: Label 'Reg. Date';
        KmCapLbl: Label 'km';
        SPCapLbl: Label 'Safety Check';
        ServiceOrderCap: Label 'Proforma Invoice %1';
        PageCap: label 'Page';
        ItemserialNoCap: Label 'Serial No.';
        CustomerReference: Label 'Reference';
        UnitOfMeasure: Text[50];
        UnitOfMeasure1: Text[50];
        Description2: Text[100];
        CustomerNoCapLbl: Label 'Customer Number';
        UnitProceCap: Label 'Unit Price';
        AmountCap: Label 'Amount';
        CurrencySymbol: Text[10];
        TotalExclVatCap: Label 'Total excl.VAT';
        VatAmountCap: Label 'VAT Amount';
        TotalInclVatCap: Label 'Total incl.VAT';
        DuedateCap: Label 'Due Date';
        DiscountCap: label 'Discount %';
        BottomText1: label 'Tax Note: No VAT liability in Sellerss Country under Articles 44 of EC Directive 2006/12.Customer to reverse charge in Buyers Country under Article 196. Intra-Community delivery.';


    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="ShowInternalInfoFrom">Boolean.</param>
    /// <param name="ShowQtyFrom">Option.</param>
    procedure InitializeRequest(ShowInternalInfoFrom: Boolean; ShowQtyFrom: Option)
    begin
        ShowInternalInfo := ShowInternalInfoFrom;
        ShowQty := ShowQtyFrom;
    end;

    local procedure FormatAddressFields(var ServiceHeader: Record "Service Header")
    begin
        FormatAddr.GetCompanyAddr(ServiceHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        //CHB2B11SEP2023<<
        FormatAddr.ServiceHeaderBillTo(CustAddr, ServiceHeader);
        //CHB2B11SEP2023>>
        ShowShippingAddr := ServiceHeader."Ship-to Code" <> '';
        if ShowShippingAddr then
            FormatAddr.ServiceOrderShipto(ShipToAddr, ServiceHeader);
    end;
}

