pageextension 50091 ItemTrackingLines extends "Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = ALL;
                trigger OnAssistEdit()
                var
                    ItemRevision: Record "Item Revision";
                    RevisionModifyConfirm: Label 'Do you want to change the revision from %1 to %2';
                begin
                    if ((Rec."Source Type" <> 39) and (Rec."Source Subtype" <> 1)) and
                         ((Rec."Source Type" <> 83) and (Rec."Source Subtype" <> 6)) and
                         ((Rec."Source Type" <> 83) and (Rec."Source Subtype" <> 2)) and
                         ((Rec."Source Type" <> 83) and (Rec."Source Subtype" <> 0)) and
                         ((Rec."Source Type" <> 5406) and (Rec."Source Subtype" <> 3))
                     then
                        exit;
                    ItemRevision.Reset();
                    ItemRevision.SetRange("Item No.", Rec."Item No.");
                    if Page.RunModal(0, ItemRevision) = Action::LookupOK then begin
                        if (Rec.Revision <> ItemRevision."Item No.") and (Rec.Revision <> '') then begin
                            if Confirm(StrSubstNo(RevisionModifyConfirm, Rec.Revision, ItemRevision.Revision), true) then
                                Rec.Revision := ItemRevision.Revision;
                        end else
                            Rec.Revision := ItemRevision.Revision;
                    end;
                end;

                trigger OnValidate()
                var
                    ItemRec: Record Item;
                begin
                    if ((Rec."Source Type" <> 39) and (Rec."Source Subtype" <> 1)) and
                        ((Rec."Source Type" <> 83) and (Rec."Source Subtype" <> 6)) and
                        ((Rec."Source Type" <> 83) and (Rec."Source Subtype" <> 2)) and
                        ((Rec."Source Type" <> 83) and (Rec."Source Subtype" <> 0)) and
                        ((Rec."Source Type" <> 5406) and (Rec."Source Subtype" <> 3))
                    then
                        exit;
                    ItemRec.Get(Rec."Item No.");
                    if Rec.Revision = '' then
                        Rec.Revision := ItemRec.Revision;
                end;
            }
        }
    }

}