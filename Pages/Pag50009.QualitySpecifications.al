page 50009 "Quality Specifications"
{
    Caption = 'Quality Specifications';
    PageType = ListPlus;
    SourceTable = "Quality Specification Header";
    ApplicationArea = all;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Spec ID"; Rec."Spec ID")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'Specification is a group of characteristics to be inspected of an item';
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE();
                    end;
                }
                field(Description; Rec.Description)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'Description for Identification purpose for  the user';
                }
                field("Specification Type"; Rec."Specification Type")
                {
                    ToolTip = 'Specifies the value of the Specification Type field.';
                }
                field("Time (Hours)"; Rec."Time (Hours)")
                {
                    ToolTip = 'Specifies the value of the Time (Hours) field.';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.';
                }
            }
            part(Control1000000006; "Quality Specification Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Spec ID" = FIELD("Spec ID");
                UpdatePropagation = Both;
            }
        }
    }
}

