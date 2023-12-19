pageextension 50056 PurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        addbefore("Location Code")
        {
            field("Quality Check"; Rec."Quality Check")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Check field.';
            }
            field("Quality Spec ID"; Rec."Quality Spec ID")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Spec ID field.';
            }
        }
        addafter(Description)
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
                trigger OnAssistEdit()
                var
                    ItemRevision: Record "Item Revision";
                    RevisionModifyConfirm: Label 'Do you want to change the revision from %1 to %2';
                begin
                    if Rec.Type <> Rec.Type::Item then
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
}
