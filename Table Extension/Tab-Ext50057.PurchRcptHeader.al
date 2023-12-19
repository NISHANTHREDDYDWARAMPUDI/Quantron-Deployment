tableextension 50057 PurchRcptHeader extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50000; "PO Mail Sent By"; Code[80])
        {
            Caption = 'PO Mail Sent By';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50001; "PO Mail Sent DateTime"; DateTime)
        {
            Caption = 'PO Mail Sent DateTime';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50003; "PO Mail Status"; Option)
        {
            Caption = 'PO Mail Status';
            Editable = false;
            OptionMembers = " ",Success,Failed;
            OptionCaption = ' ,Success,Failed';
            DataClassification = ToBeClassified;
        }
        field(50004; "PO Mail Error"; Text[500])
        {
            Caption = 'PO Mail Error';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50005; "Document Capturing No."; Code[20])
        {
            Caption = 'Document Capturing No.';
            DataClassification = ToBeClassified;
        }
        field(50006; "Approval Route"; Code[20])
        {
            TableRelation = "Workflow User Group".Code;
            Caption = 'Approval Department';
            DataClassification = ToBeClassified;
        }
    }
    procedure ProcessMaterialTransfer()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        NothingErr: Label 'Nothing to transfer';
        Transfer: Boolean;
        FinalMessageLbl: Label 'Material transfered successfully';
        Window: Dialog;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlLine: Record "Item Journal Line";
        ILE: Record "Item Ledger Entry";
        NoSufficentInventory: Label 'No sufficient inventory for the Item %1, Location %2';
    begin
        Clear(LineNo);
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
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", Rec."No.");
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetRange("Quality Check Completed", true);
        PurchRcptLine.SetFilter("New Location Code", '<>%1', '');
        if not PurchRcptLine.FindSet() then
            Error(NothingErr);
        repeat
            ILE.Reset();
            ILE.SetCurrentKey("Item No.", "Location Code", "Remaining Quantity");
            ILE.SetRange("Document No.", PurchRcptLine."Document No.");
            ILE.SetRange("Item No.", PurchRcptLine."No.");
            ILE.SetRange("Location Code", PurchRcptLine."Location Code");
            ILE.SetFilter("Remaining Quantity", '>%1', 0);
            ILE.SetAutoCalcFields("Reserved Quantity");
            ILE.SetFilter("Reserved Quantity", '%1', 0);
            if ILE.FindSet() then
                ILE.CalcSums("Remaining Quantity")
            else
                ILE.Init();

            if PurchRcptLine.Quantity <= ILE."Remaining Quantity" then begin
                Rec.TransferInventory(PurchRcptLine);
                Transfer := true;
            end else
                Error(NoSufficentInventory, PurchRcptLine."No.", PurchRcptLine."Location Code");

        until PurchRcptLine.Next() = 0;
        Window.Close();
        PostTransferMaterial();
        if Transfer then
            Message(FinalMessageLbl)
        else
            Message(NothingErr);
    end;

    procedure TransferInventory(var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        LineNo += 10000;
        ItemJnlLine.Reset();
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := PurchSetup."Reclass Journal Template";
        ItemJnlLine."Journal Batch Name" := PurchSetup."Reclass Journal Batch";
        ItemJnlLine."Posting Date" := WorkDate();
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
        ItemJnlLine.Validate("Item No.", PurchRcptLine."No.");
        ItemJnlLine.Validate(Quantity, PurchRcptLine.Quantity);
        ItemJnlLine.Validate("Location Code", PurchRcptLine."Location Code");
        ItemJnlLine.Validate("New Location Code", PurchRcptLine."New Location Code");
        ItemJnlLine.Validate("New Bin Code", PurchRcptLine."New Bin Code");
        ItemJnlLine.Validate("Dimension Set ID", PurchRcptLine."Dimension Set ID");
        ItemJnlLine.Validate("New Dimension Set ID", PurchRcptLine."Dimension Set ID");
        UpdateResEntryILE(ItemJnlLine, PurchRcptLine);
        ItemJnlLine.Insert();
    end;

    procedure UpdateResEntryILE(VAR ItemJournalLine: Record "Item Journal Line"; VAR PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        ReservationEntry: Record "Reservation Entry";
        TempReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        ItemLRec: Record Item;
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
    begin
        If ItemLRec.Get(ItemJournalLine."Item No.") then
            if ItemLRec."Item Tracking Code" = '' then
                exit;

        ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(TempItemLedgEntry, DATABASE::"Purch. Rcpt. Line", 0, PurchRcptLine."Document No.", '', 0, PurchRcptLine."Line No.");
        if not TempItemLedgEntry.FindSet() then
            exit;
        repeat
            IF TempReservationEntry.FindLast() then
                EntryNo := TempReservationEntry."Entry No."
            else
                EntryNo := 0;

            ReservationEntry.Init();
            ReservationEntry."Entry No." := EntryNo + 1;
            ReservationEntry.Validate(Positive, FALSE);
            ReservationEntry.Validate("Item No.", ItemJournalLine."Item No.");
            ReservationEntry.Validate("Location Code", ItemJournalLine."Location Code");
            ReservationEntry.Validate("Quantity (Base)", -TempItemLedgEntry."Remaining Quantity");
            ReservationEntry.Validate(Quantity, -TempItemLedgEntry."Remaining Quantity");
            ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Prospect);
            ReservationEntry.Validate("Creation Date", ItemJournalLine."Posting Date");
            ReservationEntry.Validate("Source Type", DATABASE::"Item Journal Line");
            ReservationEntry.Validate("Source Subtype", 4);
            ReservationEntry.Validate("Source ID", ItemJournalLine."Journal Template Name");
            ReservationEntry.Validate("Source Batch Name", ItemJournalLine."Journal Batch Name");
            ReservationEntry.Validate("Source Ref. No.", ItemJournalLine."Line No.");
            ReservationEntry.Validate("Shipment Date", ItemJournalLine."Posting Date");
            ReservationEntry.Validate("Serial No.", TempItemLedgEntry."Serial No.");
            ReservationEntry.Validate("Suppressed Action Msg.", FALSE);
            ReservationEntry.Validate("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
            ReservationEntry.Validate(Correction, FALSE);
            ReservationEntry.VALIDATE("Expiration Date", TempItemLedgEntry."Expiration Date");
            ReservationEntry.VALIDATE("Variant code", TempItemLedgEntry."Variant Code");
            ReservationEntry.VALIDATE("Lot No.", TempItemLedgEntry."Lot No.");
            ReservationEntry.VALIDATE("Serial No.", TempItemLedgEntry."Serial No.");
            ReservationEntry.VALIDATE("New Lot No.", TempItemLedgEntry."Lot No.");
            ReservationEntry.VALIDATE("New Serial No.", TempItemLedgEntry."Serial No.");
            ReservationEntry."Created By" := USERID;
            if (TempItemLedgEntry."Serial No." <> '') and (TempItemLedgEntry."Lot No." = '') then
                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No."
            else
                if (TempItemLedgEntry."Serial No." = '') and (TempItemLedgEntry."Lot No." <> '') then
                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No."
                else
                    if (TempItemLedgEntry."Serial No." <> '') and (TempItemLedgEntry."Lot No." <> '') then
                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot and Serial No.";
            ReservationEntry.Insert();
        until TempItemLedgEntry.Next() = 0;
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

    var
        LineNo: Integer;
        PurchSetup: Record "Purchases & Payables Setup";
        ItemJnlBatch: Record "Item Journal Batch";
        DocNo: Code[20];
}
