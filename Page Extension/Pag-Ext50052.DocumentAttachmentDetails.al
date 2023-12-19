pageextension 50052 DocumentAttachmentDetails extends "Document Attachment Details"
{
    layout
    {
        addlast(Group)
        {
            field("Include in Mail(Purch.)"; Rec."Include in Mail(Purch.)")
            {
                ApplicationArea = All;
                Visible = PurchIncludeVisible;
                ToolTip = 'Specifies the value of the Include in Mail(Purch.) field.';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."Table ID" = Database::"Purchase Header" then
            PurchIncludeVisible := true
        else
            PurchIncludeVisible := false;
    end;

    var
        PurchIncludeVisible: Boolean;
}
