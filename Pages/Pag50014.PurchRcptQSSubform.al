page 50014 "Purch. Rcpt QS Subform"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Purch. Rcpt QS Line";
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Spec ID"; Rec."Spec ID")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Spec ID field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Specification Group"; Rec."Specification Group")
                {
                    ToolTip = 'Specifies the value of the Specification Group field.';
                }
                field(Specification; Rec.Specification)
                {
                    ToolTip = 'Specifies the value of the Specification field.';
                }
                field(Responsibility; Rec.Responsibility)
                {
                    ToolTip = 'Specifies the value of the Responsibility field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field(Check; Rec.Check)
                {
                    ToolTip = 'Specifies the value of the Check field.';
                }
                field("Document Mandatory"; Rec."Document Mandatory")
                {
                    ToolTip = 'Specifies the value of the Document Mandatory field.';
                }
            }
        }
    }
    procedure OpenAttachments()
    var
        DocAttachDetails: Page "Document Attachment Details";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        DocAttachDetails.OpenForRecRef(RecRef);
        DocAttachDetails.Run();
    end;
}
