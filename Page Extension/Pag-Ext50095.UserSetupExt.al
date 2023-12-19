pageextension 50095 UserSetupExt extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {

            field("Item Block"; Rec."Item Block")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Access Item Block field.';
            }
            field("Vendor Privacy Block"; Rec."Vendor Privacy Block")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Access Vendor Privacy Block field.';
            }
            field("Access Item Journals"; Rec."Access Item Journals")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Access Item Journals field.';
            }
            field("Access Item Reclass Journal"; Rec."Access Item Reclass Journal")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Access Item Reclassification Journals field.';
            }
        }
    }
}