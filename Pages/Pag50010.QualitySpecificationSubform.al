page 50010 "Quality Specification Subform"
{

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Quality Specification Line";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Spec ID field.';
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Specification Group"; Rec."Specification Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Specification Group field.';
                }
                field(Specification; Rec.Specification)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Specification field.';
                }
                field(Responsibility; Rec.Responsibility)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility field.';
                }
                field("Document Mandatory"; Rec."Document Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Mandatory field.';
                }
            }
        }
    }
}

