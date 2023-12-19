reportextension 50008 ServiceOrder extends "Service Order Quantron"
{
    dataset
    {
        add("Service Header")
        {
            column(ShowEngImage; ShowEngImage)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(DescriptionVar; DescriptionVar)
            { }
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
            column(AssignedUserCap; AssignedUserCap)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(QtyCap; QtyCap)
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
            column(DuedateCap; DuedateCap)
            { }
            column(ReferenceCap; ReferenceCap)
            { }
            Column(CustomerNoCap; CustomerNoCap)
            { }
            column(Due_Date; "Due Date")
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(Customer_No_; "Customer No.")
            { }
            column(Document_Date; "Document Date")
            { }
            column(MileageCap; MileageCap)
            { }
        }
        add("Service Item Line")
        {
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
        }
        add("Service Line Item")
        {
            column(UnitOfMeasure1; UnitOfMeasure1)
            { }
            column(Description2; Description2)
            { }

        }
        addlast("Service Line Item")
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

        add("Service Line Resource")
        {

            column(UnitOfMeasure; UnitOfMeasure)
            { }



        }

        modify("Service Header")
        {
            trigger OnAfterAfterGetRecord()
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
        modify("Service Item Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                ServiceItem: Record "Service Item";
            begin
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
        modify("Service Line Item")
        {
            trigger OnAfterAfterGetRecord()
            var
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ItemLRec: Record Item;
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
            begin
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
        }
        modify("Service Line Resource")
        {   ////CHB2B14Nov2023<<
            // trigger OnAfterPreDataItem()
            // begin
            //     "Service Line Resource".SetRange("Print On Order", true);
            // end;
            //CHB2B14Nov2023>>


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
        }
        modify(CopyLoop)
        {
            trigger OnAfterAfterGetRecord()
            var
                FormatDocument: Codeunit "Format Document";
            begin
                if Number > 1 then
                    CopyText1 := FormatDocument.GetCOPYText;
            end;

            trigger OnAfterPreDataItem()
            begin
                CopyText1 := '';
            end;
        }

    }


    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Service Order.rdl';
        }
    }
    Var
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
        OrderdateCap: Label 'Open Date';
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
        KmCapLbl: Label 'Mileage(km)';
        SPCapLbl: Label 'Safety Check';
        ServiceOrderCap: Label 'Service Order %1';
        PageCap: label 'Page';
        ItemserialNoCap: Label 'Serial No.';
        UnitOfMeasure: Text[50];
        UnitOfMeasure1: Text[50];
        Description2: Text[100];
        DuedateCap: Label 'Due Date';
        ReferenceCap: Label 'Reference';
        CustomerNoCap: Label 'Customer Number';
        MileageCap: Label 'Mileage';
}
