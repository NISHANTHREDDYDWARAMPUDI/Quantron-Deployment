tableextension 50021 ProdOrderComponent extends "Prod. Order Component"
{
    fields
    {
        field(50000; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(50001; "Transfered Qty"; Decimal)
        {
            Caption = 'Transfered Quantity';
            DataClassification = ToBeClassified;
        }
        field(50002; "Transfer-from Location Code"; Code[20])
        {
            TableRelation = Location;
            Caption = 'Transfer-from Location Code';
            DataClassification = ToBeClassified;
        }
        field(50003; "Transfer-from Bin Code"; Code[20])
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-from Location Code"),
                                            "Item Filter" = FIELD("Item No."),
                                            "Variant Filter" = FIELD("Variant Code"));
            Caption = 'Transfer-from Bin Code';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                WMSManagement: Codeunit "WMS Management";
                BinCode: Code[20];
                IsHandled: Boolean;
                Item: Record Item;
            begin
                if Item.Get(Rec."Item No.") then
                    if BinCode <> '' then
                        Item.TestField(Type, Item.Type::Inventory);

                if Quantity > 0 then
                    BinCode := WMSManagement.BinContentLookUp("Transfer-from Location Code", "Item No.", "Variant Code", '', "Transfer-from Bin Code")
                else
                    BinCode := WMSManagement.BinLookUp("Transfer-from Location Code", "Item No.", "Variant Code", '');

                if BinCode <> '' then
                    Validate(Rec."Transfer-from Bin Code", BinCode);
            end;

            trigger OnValidate()
            var
                WMSManagement: Codeunit "WMS Management";
                WhseIntegrationMgt: Codeunit "Whse. Integration Management";
                IsHandled: Boolean;
            begin
                if "Transfer-from Bin Code" <> '' then begin
                    TestField("Transfer-from Location Code");
                    WMSManagement.FindBin("Transfer-from Location Code", "Transfer-from Bin Code", '');
                    WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Prod. Order Component",
                      FieldCaption("Transfer-from Bin Code"),
                      "Transfer-from Location Code",
                      "Transfer-from Bin Code", 0);
                end;
            end;
        }
        field(50004; Revision; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
    }

    var
        ManufacturingSetup: Record "Manufacturing Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        ItemJnlBatch: Record "Item Journal Batch";
        NothingErr: Label 'Nothing to transfer';
        LineNo: Integer;
        DocNo: Code[20];

    procedure ProcessMaterialTransfer()
    var
        ILE: Record "Item Ledger Entry";
        ProdCompOrderComp: Record "Prod. Order Component";
        Transfer: Boolean;
        ConfirmLbl: Label 'Do you want to transfer the material from below given tranfer-from location to Production location?.';
        FinalMessageLbl: Label 'Material transfered successfully';
        ReservationEntry: Record "Reservation Entry";
        ItemLRec: Record Item;
        Window: Dialog;
        NoSufficentInventory: Label 'No sufficient inventory for the Item %1, Location %2';
        ItemJnlLine: Record "Item Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if not Confirm(ConfirmLbl) then
            exit;
        Clear(LineNo);
        Clear(DocNo);
        PurchSetup.Get();
        PurchSetup.TestField("Reclass Journal Template");
        PurchSetup.TestField("Reclass Journal Batch");
        ItemJnlBatch.Get(PurchSetup."Reclass Journal Template", PurchSetup."Reclass Journal Batch");
        ItemJnlBatch.TestField("No. Series");
        DocNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series", WorkDate(), false);
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", PurchSetup."Reclass Journal Template");
        ItemJnlLine.SetRange("Journal Batch Name", PurchSetup."Reclass Journal Batch");
        if ItemJnlLine.FindSet() then
            ItemJnlLine.DeleteAll();
        Window.Open('Transfering Material....\ Item No. ##1##########');
        CheckItemsValidForTransfer();
        ProdCompOrderComp.Reset();
        ProdCompOrderComp.CopyFilters(Rec);
        ProdCompOrderComp.SetFilter("Transfer-from Location Code", '<>%1', '');
        if ProdCompOrderComp.FindSet() then
            repeat
                If ItemLRec.Get(ProdCompOrderComp."Item No.") and (ItemLRec."Item Tracking Code" <> '') then begin
                    if ProdCompOrderComp."Expected Quantity" <> ProdCompOrderComp."Transfered Qty" then begin
                        Window.Update(1, ProdCompOrderComp."Item No.");
                        TransferInventoryTrackingItems(ProdCompOrderComp);
                        Transfer := true;
                    end;
                end else begin
                    if ProdCompOrderComp."Expected Quantity" <> ProdCompOrderComp."Transfered Qty" then begin
                        Window.Update(1, ProdCompOrderComp."Item No.");
                        ILE.Reset();
                        ILE.SetCurrentKey("Item No.", "Location Code", "Remaining Quantity");
                        ILE.SetRange("Item No.", ProdCompOrderComp."Item No.");
                        ILE.SetRange("Location Code", ProdCompOrderComp."Transfer-from Location Code");
                        ILE.SetFilter("Remaining Quantity", '>%1', 0);
                        ILE.SetAutoCalcFields("Reserved Quantity");
                        ILE.SetFilter("Reserved Quantity", '%1', 0);
                        if ILE.FindSet() then
                            ILE.CalcSums("Remaining Quantity")
                        else
                            ILE.Init();

                        if ProdCompOrderComp."Expected Quantity" <= ILE."Remaining Quantity" then begin
                            TransferInventoryUntrackingItems(ProdCompOrderComp);
                            ProdCompOrderComp.Modify();
                            Transfer := true;
                        end else
                            Error(NoSufficentInventory, ProdCompOrderComp."Item No.", ProdCompOrderComp."Transfer-from Location Code");
                    end;
                end;
            until ProdCompOrderComp.Next() = 0;
        Window.Close();
        PostTransferMaterial();
        if Transfer then
            Message(FinalMessageLbl)
        else
            Message(NothingErr);
    end;

    procedure OpenItemTrackingFromLocation(var ProdOrderComp: Record "Prod. Order Component")
    var
        ItemTrackingLines: Page "Item Tracking Lines";
        TrackingSpecification: Record "Tracking Specification";
    begin
        ProdOrderComp.TestField("Item No.");
        TrackingSpecification.InitFromProdOrderCompFromLocation(ProdOrderComp);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, ProdOrderComp."Due Date");
        ItemTrackingLines.SetInbound(ProdOrderComp.IsInbound());
        ItemTrackingLines.RunModal();
    end;

    procedure TransferInventoryTrackingItems(var ProdOrderComp: Record "Prod. Order Component")
    var
        ItemJnlLine, ItemJnlLine2 : Record "Item Journal Line";
        Qty: Decimal;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ReservationEntry: Record "Reservation Entry";
        QtyTransfered: Decimal;
        SerialNoErr: Label 'Please choose sufficient tracking quantity to transfer the materail for Item no. %1, Line no. %2';
    begin
        LineNo += 10000;
        ItemJnlLine.Reset();
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := PurchSetup."Reclass Journal Template";
        ItemJnlLine."Journal Batch Name" := PurchSetup."Reclass Journal Batch";
        ItemJnlLine."Posting Date" := WorkDate();
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine.Validate("Item No.", ProdOrderComp."Item No.");
        ItemJnlLine.Validate("Location Code", ProdOrderComp."Transfer-from Location Code");
        ItemJnlLine.Validate("New Location Code", ProdOrderComp."Location Code");
        if ProdOrderComp."Transfer-from Bin Code" <> '' then
            ItemJnlLine.Validate("Bin Code", ProdOrderComp."Transfer-from Bin Code");
        if ProdOrderComp."Bin Code" <> '' then
            ItemJnlLine.Validate("New Bin Code", ProdOrderComp."Bin Code");
        ItemJnlLine.Validate("Dimension Set ID", ProdOrderComp."Dimension Set ID");

        FilterReservation(ReservationEntry, ProdOrderComp);
        if ReservationEntry.FindSet() then
            ReservationEntry.CalcSums(Quantity);
        QtyTransfered := abs(ReservationEntry.Quantity);
        ItemJnlLine.Validate(Quantity, abs(ReservationEntry.Quantity));
        if ProdOrderComp."Expected Quantity" <> QtyTransfered then
            Error(SerialNoErr, ProdOrderComp."Item No.", ProdOrderComp."Line No.");
        ItemJnlLine.Revision := ProdOrderComp.Revision;
        FilterReservation(ReservationEntry, ProdOrderComp);
        if ReservationEntry.FindSet() then
            repeat
                UpdateResEntryRLE(ItemJnlLine, ReservationEntry, Abs(ReservationEntry.Quantity));
                ReservationEntry."Location Code" := ProdOrderComp."Location Code"; //To Transfer the tracking from Loc to To Loc
                ReservationEntry.Modify();
            until ReservationEntry.next = 0
        else
            Error(SerialNoErr, ProdOrderComp."Item No.", ProdOrderComp."Line No.");

        ItemJnlLine.Insert();

        ProdOrderComp."Transfered Qty" += QtyTransfered;
        ProdOrderComp.Modify();
    end;

    procedure UpdateResEntryRLE(var ItemJournalLine: Record "Item Journal Line"; RLE: Record "Reservation Entry"; Qty: Decimal)
    var
        ReservationEntry: Record "Reservation Entry";
        TempReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        ItemLRec: Record Item;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
    begin
        If ItemLRec.Get(ItemJournalLine."Item No.") then
            if ItemLRec."Item Tracking Code" = '' then
                exit;

        IF TempReservationEntry.FindLast() then
            EntryNo := TempReservationEntry."Entry No."
        else
            EntryNo := 0;

        ReservationEntry.Init();
        ReservationEntry."Entry No." := EntryNo + 1;
        ReservationEntry.Validate(Positive, FALSE);
        ReservationEntry.Validate("Item No.", ItemJournalLine."Item No.");
        ReservationEntry.Validate("Location Code", ItemJournalLine."Location Code");
        ReservationEntry.Validate("Quantity (Base)", -Qty);
        ReservationEntry.Validate(Quantity, -Qty);
        ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Prospect);
        ReservationEntry.Validate("Creation Date", ItemJournalLine."Posting Date");
        ReservationEntry.Validate("Source Type", DATABASE::"Item Journal Line");
        ReservationEntry.Validate("Source Subtype", 4);
        ReservationEntry.Validate("Source ID", ItemJournalLine."Journal Template Name");
        ReservationEntry.Validate("Source Batch Name", ItemJournalLine."Journal Batch Name");
        ReservationEntry.Validate("Source Ref. No.", ItemJournalLine."Line No.");
        ReservationEntry.Validate("Shipment Date", ItemJournalLine."Posting Date");
        ReservationEntry.Validate("Serial No.", RLE."Serial No.");
        ReservationEntry.Validate("Suppressed Action Msg.", FALSE);
        ReservationEntry.Validate("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
        ReservationEntry.Validate(Correction, FALSE);
        ReservationEntry.VALIDATE("Expiration Date", RLE."Expiration Date");
        ReservationEntry.VALIDATE("Variant code", RLE."Variant Code");
        ReservationEntry.VALIDATE("Lot No.", RLE."Lot No.");
        ReservationEntry.VALIDATE("Serial No.", RLE."Serial No.");
        ReservationEntry.VALIDATE("New Lot No.", RLE."Lot No.");
        ReservationEntry.VALIDATE("New Serial No.", RLE."Serial No.");
        ReservationEntry."Created By" := USERID;
        case true of
            (RLE."Serial No." <> '') and (RLE."Lot No." = ''):
                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No.";
            (RLE."Serial No." = '') and (RLE."Lot No." <> ''):
                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
            (RLE."Serial No." <> '') and (RLE."Lot No." <> ''):
                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot and Serial No.";
        end;
        ReservationEntry.Revision := RLE.Revision;
        ReservationEntry.Insert();
    end;

    procedure TransferInventoryUntrackingItems(var ProdOrderComp: Record "Prod. Order Component")
    var
        ILE: Record "Item Ledger Entry";
        ItemJnlLine, ItemJnlLine2 : Record "Item Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
        LineNo += 10000;
        ItemJnlLine.Reset();
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := PurchSetup."Reclass Journal Template";
        ItemJnlLine."Journal Batch Name" := PurchSetup."Reclass Journal Batch";
        ItemJnlLine."Posting Date" := WorkDate();
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine.Validate("Item No.", ProdOrderComp."Item No.");
        ItemJnlLine.Validate("Location Code", ProdOrderComp."Transfer-from Location Code");
        ItemJnlLine.Validate("New Location Code", ProdOrderComp."Location Code");
        if ProdOrderComp."Transfer-from Bin Code" <> '' then
            ItemJnlLine.Validate("Bin Code", ProdOrderComp."Transfer-from Bin Code");
        if ProdOrderComp."Bin Code" <> '' then
            ItemJnlLine.Validate("New Bin Code", ProdOrderComp."Bin Code");
        ItemJnlLine.Validate(Quantity, ProdOrderComp."Expected Quantity");
        ItemJnlLine.Validate("Dimension Set ID", ProdOrderComp."Dimension Set ID");
        ItemJnlLine.Validate("New Dimension Set ID", ProdOrderComp."Dimension Set ID");
        ItemJnlLine.Revision := ProdOrderComp.Revision;
        ItemJnlLine.Insert();

        ProdOrderComp."Transfered Qty" := ProdOrderComp."Expected Quantity";
        ProdOrderComp.modify();
    end;

    local procedure FilterReservation(var ReservationEntry: Record "Reservation Entry"; var ProdOrderComp: Record "Prod. Order Component")
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Item No.", ProdOrderComp."Item No.");
        ReservationEntry.SetRange("Location Code", ProdOrderComp."Transfer-from Location Code");
        ReservationEntry.SetRange("Source Type", 5407);
        ReservationEntry.SetRange("Source Subtype", 3);
        ReservationEntry.SetRange("Source ID", ProdOrderComp."Prod. Order No.");
        ReservationEntry.SetFilter("Source Batch Name", '');
        ReservationEntry.SetRange("Source Prod. Order Line", ProdOrderComp."Prod. Order Line No.");
        ReservationEntry.SetRange("Source Ref. No.", ProdOrderComp."Line No.");
        ReservationEntry.SetFilter("Variant Code", ProdOrderComp."Variant Code");
    end;

    local procedure CheckItemsValidForTransfer()
    var
        ProdOrderComp: Record "Prod. Order Component";
        SameLocErr: Label 'Transfer - From Location code is same as Location code for Item no. %1, Line no. %2';
    begin
        ProdOrderComp.Reset();
        ProdOrderComp.CopyFilters(Rec);
        ProdOrderComp.SetFilter("Transfer-from Location Code", '<>%1', '');
        if not ProdOrderComp.FindSet() then
            Error(NothingErr);
        repeat
            ProdOrderComp.TestField("Transfer-from Location Code");
            ProdOrderComp.TestField("Location Code");
            if ProdOrderComp."Transfer-from Location Code" = ProdOrderComp."Location Code" then
                Error(SameLocErr, ProdOrderComp."Item No.", ProdOrderComp."Line No.");
        until ProdOrderComp.Next() = 0;
    end;

    local procedure PostTransferMaterial()
    var
        ItemJnlLine2: Record "Item Journal Line";
    begin
        ItemJnlLine2.Reset();
        ItemJnlLine2.SetRange("Journal Template Name", PurchSetup."Reclass Journal Template");
        ItemJnlLine2.SetRange("Journal Batch Name", PurchSetup."Reclass Journal Batch");
        if ItemJnlLine2.FindSet() then
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnlLine2);
    end;
}