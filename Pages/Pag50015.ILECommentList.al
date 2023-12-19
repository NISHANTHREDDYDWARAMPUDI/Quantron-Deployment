page 50015 "ILE Comment List"
{
    ApplicationArea = All;
    Caption = 'Comment List';
    PageType = List;
    SourceTable = "ILE Comment";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
