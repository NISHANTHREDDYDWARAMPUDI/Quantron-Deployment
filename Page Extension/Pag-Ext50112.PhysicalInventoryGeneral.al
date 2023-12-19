pageextension 50112 PhysicalINventoryJournal extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Salespers./Purch. Code")
        {
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = All;
            }
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
