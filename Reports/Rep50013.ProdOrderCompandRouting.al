report 50013 "ProdOrderRoutingByCompFilter"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\ProdOrderRoutingByCompFilter.rdl';
    ApplicationArea = all;
    Caption = 'Prod. Order Comp. By Item Filter';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.");
            RequestFilterFields = Status, "No.";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(Status_ProductionOrder; Status)
            {
                IncludeCaption = true;
            }
            column(No_ProductionOrder; "No.")
            {
                IncludeCaption = true;
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(PrdOdrCmptsandRtngLinsCpt; PrdOdrCmptsandRtngLinsCptLbl)
            {
            }
            column(ProductionOrderDescCapt; ProductionOrderDescCaptLbl)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {

            }
            column(ProdLineNoLbl; ProdLineNoLbl)
            {

            }
            column(Qtycap; Qtycap)
            { }
            column(ItemNoCap; ItemNoCap)
            { }
            column(Description2label; Description2label)
            { }
            column(WorkDescription_ProductionOrder; WorkDescription)
            {
            }
            column(ShowDeImage; ShowDeImage)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                RequestFilterFields = "Item No.", "Line No.";
                column(No1_ProductionOrder; "Production Order"."No.")
                {
                }
                column(Desc_ProductionOrder; "Production Order".Description)
                {
                }
                column(Desc_ProdOrderLine; Description)
                {
                }
                column(Quantity_ProdOrderLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ProdOrderLine; "Item No.")
                {
                }
                column(StartgDate_ProdOrderLine; Format("Starting Date"))
                {
                }
                column(StartgTime_ProdOrderLine; "Starting Time")
                {
                    IncludeCaption = true;
                }
                column(EndingDate_ProdOrderLine; Format("Ending Date"))
                {
                }
                column(EndingTime_ProdOrderLine; "Ending Time")
                {
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderLine; Format("Due Date"))
                {
                }
                column(LineNo_ProdOrderLine; "Line No.")
                {
                }
                column(ProdOdrLineStrtngDteCapt; ProdOdrLineStrtngDteCaptLbl)
                {
                }
                column(ProdOrderLineEndgDteCapt; ProdOrderLineEndgDteCaptLbl)
                {
                }
                column(ProdOrderLineDueDateCapt; ProdOrderLineDueDateCaptLbl)
                {
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    RequestFilterFields = "Item No.";
                    column(ItemNo_PrdOrdrComp; "Item No.")
                    {
                    }
                    column(ItemNo_PrdOrdrCompCaption; FieldCaption("Item No."))
                    {
                    }
                    column(Description_ProdOrderComp; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantityper_ProdOrderComp; "Quantity per")
                    {
                        IncludeCaption = true;
                    }
                    column(UntofMesrCode_PrdOrdrComp; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(RemainingQty_PrdOrdrComp; "Remaining Quantity")
                    {
                        IncludeCaption = true;
                    }
                    column(DueDate_PrdOrdrComp; Format("Due Date"))
                    {
                    }
                    column(ProdOrdrLinNo_PrdOrdrComp; "Prod. Order Line No.")
                    {
                    }
                    column(LineNo_PrdOrdrComp; "Line No.")
                    {
                    }
                    column(VendorItemNo; VendorItemNo)
                    {
                    }
                    column(Description_2; "Description 2")
                    {
                        IncludeCaption = true;
                    }
                    column(UnitOfMeasure; UnitOfMeasure)
                    { }
                    column(UnitOfMeasureCode_Caption; ML_UnitOfMeasureCode_lbl)
                    {
                    }
                    dataitem("Reservation Entry"; "Reservation Entry")
                    {
                        DataItemLinkReference = "Prod. Order Component";
                        DataItemLink = "Source ID" = FIELD("Prod. Order No."), "Source Prod. Order Line" = FIELD("Prod. Order Line No."), "Source Ref. No." = FIELD("Line No.");
                        DataItemTableView = SORTING("Entry No.", Positive) ORDER(Ascending) WHERE("Source Type" = CONST(5407), "Source Subtype" = CONST(3), "Item Tracking" = CONST("Serial No."));

                        column(Component_SerialNo; "Serial No.")
                        {
                        }
                        column(SerialNo_Label; ML_SerialNoLbl)
                        {
                        }
                        dataitem("Item Tracking Comment"; "Item Tracking Comment")
                        {
                            DataItemLinkReference = "Reservation Entry";
                            DataItemLink = "Item No." = FIELD("Item No."), "Serial/Lot No." = FIELD("Serial No.");
                            DataItemTableView = SORTING(Type, "Item No.", "Variant Code", "Serial/Lot No.", "Line No.") WHERE(Type = CONST("Serial No."));

                            column(Comment_TrackingComment; Comment)
                            {
                            }

                        }
                    }

                    dataitem("Item Ledger Entry"; "Item Ledger Entry")
                    {
                        DataItemLinkReference = "Prod. Order Component";
                        DataItemLink = "Order No." = Field("Prod. Order No."), "Order Line No." = Field("Prod. Order Line No."), "Prod. Order Comp. Line No." = Field("Line No."), "Item No." = Field("Item No.");
                        DataItemTableView = Sorting("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date") where("Entry Type" = Const(Consumption));
                        column(Ledger_SerialNo; "Serial No.")
                        {
                        }
                        column(SerialNoPosted_Label; ML_SerialNoPostedLbl)
                        {
                        }

                        dataitem(ItemTrackingComment2; "Item Tracking Comment")
                        {
                            DataItemLinkReference = "Item Ledger Entry";
                            DataItemLink = "Item No." = Field("Item No."), "Serial/Lot No." = field("Serial No.");
                            DataItemTableView = SORTING(Type, "Item No.", "Variant Code", "Serial/Lot No.", "Line No.") WHERE(Type = CONST("Serial No."));

                            column(Comment_LedgerTrackingComment; Comment)
                            {
                            }
                        }

                        trigger OnPreDataItem()
                        begin
                            SetFilter("Serial No.", '<>%1', '');
                        end;

                    }
                    trigger OnAfterGetRecord()
                    var
                        ItemRec: Record Item;
                        UnitOfMeasureRec: Record "Unit of Measure";
                        UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                    begin
                        if ProductionJrnlMgt.RoutingLinkValid("Prod. Order Component", "Prod. Order Line") then
                            CurrReport.Skip();

                        if not ItemRec.Get("Item No.") then
                            Clear(ItemRec);
                        if ItemRec."Vendor Item No." <> '' then
                            VendorItemNo := ItemRec."Vendor Item No."
                        else
                            if ItemRec."Manufacturer Item No." <> '' then
                                VendorItemNo := ItemRec."Manufacturer Item No.";
                        if "Unit of Measure Code" = '' then
                            UnitOfMeasure := ''
                        else begin
                            if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                                UnitOfMeasureRec.Init();
                            UnitOfMeasure := UnitOfMeasureRec.Description;
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

                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Routing No." = FIELD("Routing No."), "Routing Reference No." = FIELD("Routing Reference No."), "Prod. Order No." = FIELD("Prod. Order No."), Status = FIELD(Status);
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                    column(OprNo_ProdOrderRtngLine; "Operation No.")
                    {
                    }
                    column(OprNo_ProdOrderRtngLineCaption; FieldCaption("Operation No."))
                    {
                    }
                    column(Type_PrdOrdRtngLin; Type)
                    {
                        IncludeCaption = true;
                    }
                    column(No_ProdOrderRoutingLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(LinDesc_ProdOrderRtngLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(StrgDt_ProdOrderRtngLine; Format("Starting Date"))
                    {
                    }
                    column(LinStrgTime_PrdOrdRtngLin; "Starting Time")
                    {
                        IncludeCaption = true;
                    }
                    column(EndgDte_ProdOrdrRtngLine; Format("Ending Date"))
                    {
                    }
                    column(EndgTime_ProdOrdrRtngLin; "Ending Time")
                    {
                        IncludeCaption = true;
                    }
                    column(RoutgNo_ProdOrdrRtngLine; "Routing No.")
                    {
                    }
                    column(WorkPlaceGroup_Caption; ML_WorkPlaceGroup__lbl)
                    {
                    }
                    dataitem(CompLink; "Prod. Order Component")
                    {
                        DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Routing Reference No."), "Routing Link Code" = FIELD("Routing Link Code");
                        DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Link Code", "Flushing Method") WHERE("Routing Link Code" = FILTER(<> ''));
                        column(ItemNo_CompLink; "Item No.")
                        {
                        }
                        column(Description_CompLink; Description)
                        {
                        }
                        column(Quantityper_CompLink; "Quantity per")
                        {
                        }
                        column(UntofMeasureCode_CompLink; "Unit of Measure Code")
                        {
                        }
                        column(DueDate_CompLink; Format("Due Date"))
                        {
                        }
                        column(RemainingQty_CompLink; "Remaining Quantity")
                        {
                        }
                        column(LineNo_CompLink; "Line No.")
                        {
                        }
                        column(RoutingLinkCode_CompLink; "Routing Link Code")
                        {
                        }
                        dataitem(CompLinkReservation; "Reservation Entry")
                        {
                            DataItemLinkReference = CompLink;
                            DataItemLink = "Source ID" = FIELD("Prod. Order No."),
               "Source Prod. Order Line" = FIELD("Prod. Order Line No."),
               "Source Ref. No." = FIELD("Line No.");
                            DataItemTableView = SORTING("Entry No.", Positive) ORDER(Ascending) WHERE("Source Type" = CONST(5407),
               "Source Subtype" = CONST(3), "Item Tracking" = CONST("Serial No."));

                            column(Link_Component_SerialNo; "Serial No.")
                            {
                            }
                            column(Link_SerialNo_Label; ML_SerialNoLbl)
                            {
                            }
                            dataitem("Link Tracking Comment"; "Item Tracking Comment")
                            {
                                DataItemLinkReference = CompLinkReservation;
                                DataItemLink = "Item No." = FIELD("Item No."), "Serial/Lot No." = FIELD("Serial No.");
                                DataItemTableView = SORTING(Type, "Item No.", "Variant Code", "Serial/Lot No.", "Line No.") WHERE(Type = CONST("Serial No."));

                                column(Link_Comment_TrackingComment; Comment)
                                {
                                }

                            }
                        }

                        dataitem("Link Item Ledger Entry"; "Item Ledger Entry")
                        {
                            DataItemLinkReference = CompLink;
                            DataItemLink = "Order No." = Field("Prod. Order No."), "Order Line No." = Field("Prod. Order Line No."), "Prod. Order Comp. Line No." = Field("Line No."), "Item No." = Field("Item No.");
                            DataItemTableView = Sorting("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date") where("Entry Type" = Const(Consumption));
                            column(Link_Ledger_SerialNo; "Serial No.")
                            {
                            }
                            column(Link_SerialNoPosted_Label; ML_SerialNoPostedLbl)
                            {
                            }

                            dataitem(Link_ItemTrackingComment2; "Item Tracking Comment")
                            {
                                DataItemLinkReference = "Link Item Ledger Entry";
                                DataItemLink = "Item No." = Field("Item No."), "Serial/Lot No." = field("Serial No.");
                                DataItemTableView = SORTING(Type, "Item No.", "Variant Code", "Serial/Lot No.", "Line No.") WHERE(Type = CONST("Serial No."));

                                column(Link_Comment_LedgerTrackingComment; Comment)
                                {
                                }
                            }

                            trigger OnPreDataItem()
                            begin
                                SetFilter("Serial No.", '<>%1', '');
                            end;

                        }
                    }

                }
            }
            trigger OnAfterGetRecord()
            var
                i: Integer;
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";
                Currency: Record Currency;
                PaymentTerms: Record "Payment Terms";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                WorkDescription := GetWorkDescription();
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
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
    trigger OnPreReport()
    var
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        RespCenter: Record "Responsibility Center";
        Currency: Record Currency;
        PaymentTerms: Record "Payment Terms";
        GeneralLedgerSetup: Record "General Ledger Setup";
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
        end;
    end;

    var
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        CurrReportPageNoCaptLbl: Label 'Page';
        PrdOdrCmptsandRtngLinsCptLbl: Label 'Prod. Order - Components and Routing Lines';
        ProductionOrderDescCaptLbl: Label 'Description';
        ProdOdrLineStrtngDteCaptLbl: Label 'Starting Date';
        ProdOrderLineEndgDteCaptLbl: Label 'Ending Date';
        ProdOrderLineDueDateCaptLbl: Label 'Due Date';
        CompanyInfo: Record "Company Information";
        ProdLineNoLbl: Label 'Prod. Order Line No.';
        WorkDescription: Text;
        VendorItemNo: Text[50];
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        ShowDeImage: Boolean;
        ShowEngImage: Boolean;
        languageCodevar: Record Language;
        UnitOfMeasure: text[100];
        ItemNoCap: label 'Item No.';
        Description2label: label 'Description 2';
        Qtycap: Label 'QTY';
        ML_SerialNoLbl: Label 'S/N:';
        ML_SerialNoPostedLbl: Label 'S/N (P):';
        ML_UnitOfMeasureCode_lbl: Label 'Unit';
        ML_WorkPlaceGroup__lbl: Label 'WPG';
}

