pageextension 50058 ItemJournal extends "Item Journal"
{
    layout
    {
        addafter(Description)
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Comment field.';
            }
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Revision field.';
            }
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                ItemJnlLine: Record "Item Journal Line";
            begin
                ItemJnlLine.Copy(Rec);
                ItemJnlLine.SetFilter(Comment, '%1', '');
                if ItemJnlLine.FindFirst() then
                    ItemJnlLine.FieldError(Comment);
            end;
        }
    }
    trigger OnOpenPage()
    begin
        UsersetupRec.GET(UserId);
        if not UsersetupRec."Access Item Journals" then
            Error(Text000);
    end;

    var

        UsersetupRec: record "User Setup";
        Text000: Label 'You dont have access to process item journal';

}
