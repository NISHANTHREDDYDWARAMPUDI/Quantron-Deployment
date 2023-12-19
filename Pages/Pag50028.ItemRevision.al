page 50028 "Item Revision"
{
    ApplicationArea = All;
    Caption = 'Item Revision';
    PageType = List;
    SourceTable = "Item Revision";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field(Revision; Rec.Revision)
                {
                    ToolTip = 'Specifies the value of the Revision  field.';
                }
            }
        }
    }
}
