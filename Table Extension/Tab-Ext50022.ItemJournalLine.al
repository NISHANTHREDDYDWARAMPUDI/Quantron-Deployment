tableextension 50022 ItemJournalLine extends "Item Journal Line"
{
    fields
    {
        field(50000; Comment; Code[20])
        {
            TableRelation = "ILE Comment".Code;
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
        field(50001; "Comment Description"; Code[50])
        {
            Caption = 'Comment Description';
            DataClassification = ToBeClassified;
        }
        field(50002; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
            trigger OnLookup()
            var
                ItemRevision: Record "Item Revision";
                RevisionModifyConfirm: Label 'Do you want to change the revision from %1 to %2';
            begin
                if not (Rec."Entry Type" IN [Rec."Entry Type"::Purchase,
                                            Rec."Entry Type"::"Positive Adjmt.",
                                            Rec."Entry Type"::Output]) then
                    exit;
                ItemRevision.Reset();
                ItemRevision.SetRange("Item No.", Rec."No.");
                if Page.RunModal(0, ItemRevision) = Action::LookupOK then begin
                    if (Rec.Revision <> ItemRevision."Item No.") and (Rec.Revision <> '') then begin
                        if Confirm(StrSubstNo(RevisionModifyConfirm, Rec.Revision, ItemRevision.Revision), true) then
                            Rec.Revision := ItemRevision.Revision;
                    end else
                        Rec.Revision := ItemRevision.Revision;
                end;
            end;
        }
    }
}
