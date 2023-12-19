tableextension 50005 ProductionOrderExt extends "Production Order"
{
    fields
    {
        field(50000; "Work Description"; BLOB)
        {
            Caption = 'Work Description';
        }
        field(50001; "Order Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Type';
            OptionMembers = " ","Internal",External;
            OptionCaption = ' ,Internal,External';
        }
    }
    var
        Window: Dialog;

    procedure GetWorkDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Work Description");
        "Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Work Description")));
    end;

    procedure CreateInternalShipDoc(): Boolean
    var
        ILE: Record "Item Ledger Entry";
        MFGSetupLrec: Record "Manufacturing Setup";
        ProdOrderLineLrec: Record "Prod. Order Line";
        TransferHdrLrec, TransferHdrLrec2 : Record "Transfer Header";
        TransferLineLrec: Record "Transfer Line";
        TransferOrderPostTransfer: Codeunit "TransferOrder-Post Transfer";
        LineNoLvar: Integer;
        InternalShipDocErr: Label 'Internal Shipment document %1 has already been created for this production order.';
        InventoryErr: Label '';
        LocationErr: Label 'Item No. %1 is not in the internal shipment location %2. Current value is %3';
        OutputErr: Label 'Output has not yet posted for the item no. %1 & line no. %2';
        WindowLbl: Label 'Creating internal shipment....\ Current Step : #3################# \ Processing Line #1####### \ Total Lines #2###### ';
        ProcessingLine: Integer;
        TotalLines: Integer;
    begin
        Window.Open(WindowLbl);
        MFGSetupLrec.Get();
        Rec.TestField("Order Type");
        MFGSetupLrec.TestField("Inter Ship Transfer From");
        MFGSetupLrec.TestField("Inter Ship Transfer To");
        MFGSetupLrec.TestField("Int Ship Cust No.");

        ProdOrderLineLrec.Reset();
        ProdOrderLineLrec.SetRange(Status, Rec.Status);
        ProdOrderLineLrec.SetRange("Prod. Order No.", Rec."No.");
        ProdOrderLineLrec.SetFilter("Item No.", '<>%1', '');
        ProdOrderLineLrec.SetFilter("Location Code", '<>%1', MFGSetupLrec."Inter Ship Transfer From");
        if ProdOrderLineLrec.FindFirst() then
            Error(LocationErr, ProdOrderLineLrec."Item No.", MFGSetupLrec."Inter Ship Transfer From", ProdOrderLineLrec."Location Code");

        ProdOrderLineLrec.Reset();
        ProdOrderLineLrec.SetRange(Status, Rec.Status);
        ProdOrderLineLrec.SetRange("Prod. Order No.", Rec."No.");
        ProdOrderLineLrec.SetFilter("Item No.", '<>%1', '');
        if ProdOrderLineLrec.FindSet() then
            repeat
                TotalLines += 1;
                ILE.Reset();
                ILE.SetCurrentKey("Item No.", "Location Code");
                ILE.SetRange("Order Type", ILE."Order Type"::Production);
                ILE.SetRange("Order No.", ProdOrderLineLrec."Prod. Order No.");
                ILE.SetRange("Order Line No.", ProdOrderLineLrec."Line No.");
                ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
                ILE.SetRange("Item No.", ProdOrderLineLrec."Item No.");
                ILE.SetRange("Location Code", MFGSetupLrec."Inter Ship Transfer From");
                ILE.SetFilter("Remaining Quantity", '<>%1', 0);
                if ILE.IsEmpty then
                    Error(OutputErr, ProdOrderLineLrec."Item No.", ProdOrderLineLrec."Line No.");
            until ProdOrderLineLrec.Next() = 0;

        TransferHdrLrec.Reset();
        TransferHdrLrec.SetRange("Released Prod. Order No,", Rec."No.");
        if TransferHdrLrec.FindFirst() then
            Error(InternalShipDocErr, TransferHdrLrec."No.");

        Window.Update(2, TotalLines);

        TransferHdrLrec.Init();
        TransferHdrLrec."No." := '';
        TransferHdrLrec.Insert(true);
        TransferHdrLrec.Validate("Transfer-from Code", MFGSetupLrec."Inter Ship Transfer From");
        TransferHdrLrec.Validate("Transfer-to Code", MFGSetupLrec."Inter Ship Transfer To");
        TransferHdrLrec.Validate("Direct Transfer", true);
        TransferHdrLrec."Released Prod. Order No," := Rec."No.";
        TransferHdrLrec.Modify(true);

        LineNoLvar := 10000;
        ProdOrderLineLrec.Reset();
        ProdOrderLineLrec.SetRange(Status, Rec.Status);
        ProdOrderLineLrec.SetRange("Prod. Order No.", Rec."No.");
        ProdOrderLineLrec.SetFilter("Item No.", '<>%1', '');
        if ProdOrderLineLrec.FindSet() then
            repeat
                ProcessingLine += 1;
                Window.Update(1, ProcessingLine);
                ILE.Reset();
                ILE.SetCurrentKey("Item No.", "Location Code");
                ILE.SetRange("Order Type", ILE."Order Type"::Production);
                ILE.SetRange("Order No.", ProdOrderLineLrec."Prod. Order No.");
                ILE.SetRange("Order Line No.", ProdOrderLineLrec."Line No.");
                ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
                ILE.SetRange("Item No.", ProdOrderLineLrec."Item No.");
                ILE.SetRange("Location Code", MFGSetupLrec."Inter Ship Transfer From");
                ILE.CalcSums("Remaining Quantity");

                TransferLineLrec.Init();
                TransferLineLrec."Document No." := TransferHdrLrec."No.";
                TransferLineLrec."Line No." := LineNoLvar;
                LineNoLvar += 10000;
                TransferLineLrec.Insert(true);
                TransferLineLrec.Validate("Item No.", ProdOrderLineLrec."Item No.");
                TransferLineLrec.Validate("Unit of Measure Code", ProdOrderLineLrec."Unit of Measure Code");
                TransferLineLrec.Validate(Quantity, ILE."Remaining Quantity");
                TransferLineLrec.Modify(true);
                CreateTrackingAndServiceItems(ProdOrderLineLrec, TransferLineLrec);
            until ProdOrderLineLrec.Next() = 0;
        TransferHdrLrec2.Get(TransferHdrLrec."No.");
        TransferOrderPostTransfer.Run(TransferHdrLrec2)
        //exit();
    end;

    local procedure CreateTrackingAndServiceItems(var ProdOrderLineLrec: Record "Prod. Order Line"; var TransferLineLrec: Record "Transfer Line")
    var
        ILE: Record "Item Ledger Entry";
        MFGSetupLrec: Record "Manufacturing Setup";
        ProdOrderComponent: Record "Prod. Order Component";
        ServiceItemLrec: Record "Service Item";
        ServiceItemComp: Record "Service Item Component";
        CreateServiceItemLbl: Label 'Creating Service Item';
        EventSubs: Codeunit "Event Subscribers";
    begin
        Window.Update(3, CreateServiceItemLbl);
        MFGSetupLrec.Get();
        ILE.Reset();
        ILE.SetCurrentKey("Item No.", "Location Code");
        ILE.SetRange("Order Type", ILE."Order Type"::Production);
        ILE.SetRange("Order No.", ProdOrderLineLrec."Prod. Order No.");
        ILE.SetRange("Order Line No.", ProdOrderLineLrec."Line No.");
        ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
        ILE.SetRange("Item No.", ProdOrderLineLrec."Item No.");
        ILE.SetRange("Location Code", MFGSetupLrec."Inter Ship Transfer From");
        ILE.SetFilter("Remaining Quantity", '<>%1', 0);
        ILE.SetFilter("Serial No.", '<>%1', '');
        if ILE.FindSet() then
            repeat
                ServiceItemLrec.Init();
                ServiceItemLrec."No." := '';
                ServiceItemLrec.Insert(true);
                ServiceItemLrec.Validate("Item No.", ILE."Item No.");
                ServiceItemLrec.Validate("Serial No.", ILE."Serial No.");
                ServiceItemLrec.Validate("Customer No.", MFGSetupLrec."Int Ship Cust No.");
                ServiceItemLrec."Prod. Order No." := ProdOrderLineLrec."Prod. Order No.";
                ServiceItemLrec."Prod. Order Line No." := ProdOrderLineLrec."Line No.";
                ServiceItemLrec.Modify(true);
                EventSubs.TransferComponentsToServiceItems(ProdOrderLineLrec, ServiceItemLrec);
                CreateItemTrackingForTransferShipLine(TransferLineLrec, ILE);
            until ILE.Next() = 0;
    end;

    local procedure CreateItemTrackingForTransferShipLine(var TransferLineLrec: Record "Transfer Line"; var ILE: Record "Item Ledger Entry")
    var
        ReservationEntry, ReservationEntry2 : Record "Reservation Entry";
        EntryNum: Integer;
        UpdateTrackingLbl: Label 'Updating Tracking';
    begin
        Window.Update(3, UpdateTrackingLbl);
        ReservationEntry2.RESET;
        IF ReservationEntry2.FINDLAST THEN
            EntryNum := ReservationEntry2."Entry No." + 1
        ELSE
            EntryNum := 1;

        //Shipment 
        ReservationEntry.INIT;
        ReservationEntry."Entry No." := EntryNum;
        ReservationEntry.VALIDATE(Positive, false);
        ReservationEntry.VALIDATE("Item No.", TransferLineLrec."Item No.");
        ReservationEntry.VALIDATE("Location Code", TransferLineLrec."Transfer-from Code");
        ReservationEntry.VALIDATE("Quantity (Base)", -1 * ILE."Remaining Quantity");
        ReservationEntry.VALIDATE(Quantity, -1 * ILE."Remaining Quantity");
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.VALIDATE("Creation Date", WorkDate());
        ReservationEntry.VALIDATE("Source Type", DATABASE::"Transfer line");
        ReservationEntry.VALIDATE("Source Subtype", 0);
        ReservationEntry.VALIDATE("Source ID", TransferLineLrec."Document No.");
        ReservationEntry.VALIDATE("Source Prod. Order Line", 0);
        ReservationEntry.VALIDATE("Source Ref. No.", TransferLineLrec."Line No.");
        ReservationEntry.VALIDATE("Expected Receipt Date", WorkDate());
        ReservationEntry.VALIDATE("Suppressed Action Msg.", FALSE);
        ReservationEntry.VALIDATE("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
        ReservationEntry.VALIDATE("Expiration Date", ILE."Expiration Date");
        ReservationEntry.VALIDATE("Variant code", ILE."Variant Code");
        ReservationEntry.VALIDATE("Lot No.", ILE."Lot No.");
        ReservationEntry.VALIDATE("Serial No.", ILE."Serial No.");
        ReservationEntry."Created By" := USERID;
        if (ILE."Serial No." <> '') and (ILE."Lot No." = '') then
            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No."
        else
            if (ILE."Serial No." = '') and (ILE."Lot No." <> '') then
                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No."
            else
                if (ILE."Serial No." <> '') and (ILE."Lot No." <> '') then
                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot and Serial No.";
        ReservationEntry.VALIDATE(Correction, FALSE);
        ReservationEntry.INSERT;

        //Receipt
        ReservationEntry.INIT;
        ReservationEntry."Entry No." := EntryNum + 1;
        ReservationEntry.VALIDATE(Positive, true);
        ReservationEntry.VALIDATE("Item No.", TransferLineLrec."Item No.");
        ReservationEntry.VALIDATE("Location Code", TransferLineLrec."Transfer-to Code");
        ReservationEntry.VALIDATE("Quantity (Base)", ILE."Remaining Quantity");
        ReservationEntry.VALIDATE(Quantity, ILE."Remaining Quantity");
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.VALIDATE("Creation Date", WorkDate());
        ReservationEntry.VALIDATE("Source Type", DATABASE::"Transfer line");
        ReservationEntry.VALIDATE("Source Subtype", 1);
        ReservationEntry.VALIDATE("Source ID", TransferLineLrec."Document No.");
        ReservationEntry.VALIDATE("Source Prod. Order Line", 0);
        ReservationEntry.VALIDATE("Source Ref. No.", TransferLineLrec."Line No.");
        ReservationEntry.VALIDATE("Expected Receipt Date", WorkDate());
        ReservationEntry.VALIDATE("Suppressed Action Msg.", FALSE);
        ReservationEntry.VALIDATE("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
        ReservationEntry.VALIDATE("Expiration Date", ILE."Expiration Date");
        ReservationEntry.VALIDATE("Variant code", ILE."Variant Code");
        ReservationEntry.VALIDATE("Lot No.", ILE."Lot No.");
        ReservationEntry.VALIDATE("Serial No.", ILE."Serial No.");
        ReservationEntry."Created By" := USERID;
        if (ILE."Serial No." <> '') and (ILE."Lot No." = '') then
            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No."
        else
            if (ILE."Serial No." = '') and (ILE."Lot No." <> '') then
                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No."
            else
                if (ILE."Serial No." <> '') and (ILE."Lot No." <> '') then
                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot and Serial No.";
        ReservationEntry.VALIDATE(Correction, FALSE);
        ReservationEntry.INSERT;
    end;
}
