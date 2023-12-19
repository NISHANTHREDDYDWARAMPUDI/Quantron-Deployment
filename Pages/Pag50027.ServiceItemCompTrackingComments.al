page 50027 "Service Item Comp.Trac Comment"
{
    AutoSplitKey = true;
    Caption = 'Service Item Component Tracking Comments';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Item Tracking Comment";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Date; Rec.Date)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a date to reference the comment.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the item tracking comment.';
                }
            }
        }
    }

    actions
    {
    }
}

