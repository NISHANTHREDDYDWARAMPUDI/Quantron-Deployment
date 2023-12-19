pageextension 50076 WorkCenterCard extends "Work Center Card"
{
    layout
    {
        addlast(General)
        {
            field("Work Instruction"; Rec."Work Instruction")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Work Instruction field.';
            }
        }
        addbefore(Control1900383207)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Work Center"),
                              "No." = FIELD("No.");
            }
        }
    }
}
