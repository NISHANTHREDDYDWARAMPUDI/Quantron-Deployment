pageextension 50114 PageExtension50105 extends "Bank Account List"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
    }
}
