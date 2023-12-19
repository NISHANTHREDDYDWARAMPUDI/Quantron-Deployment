pageextension 50044 ProdOrderRouting extends "Prod. Order Routing"
{
    layout
    {
        addafter(Description)
        {
            field("Work Instruction"; Rec."Work Instruction")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Work Instruction field.';
            }
            field("Quality Check"; Rec."Quality Check")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Quality Check field.';
                Editable = false;
            }
            field("Quality Spec ID"; Rec."Quality Spec ID")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Spec ID field.';
            }
            field("Quality Check Completed"; Rec."Quality Check Completed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Check Completed field.';
            }
            field("Send Operation Completion Mail"; Rec."Send Operation Completion Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Send Operation Complete Mail field.';
            }
        }
        addbefore(Control1900383207)
        {
            part("Attached Documents"; "Document Attachment Fact_B2B")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Work Center"),
                              "No." = FIELD("Work Center No.");
            }
        }
    }

    actions
    {
        addafter("Quality Measures")
        {
            action("Quality Spec Doc")
            {
                ApplicationArea = all;
                Caption = 'Quality Spec Document';
                Image = TaskQualityMeasure;
                RunObject = Page "Prod Order Routing QS";
                RunPageLink = Status = FIELD(Status),
                                  "Prod. Order No." = FIELD("Prod. Order No."),
                                  "Routing Reference No." = FIELD("Routing Reference No."),
                                  "Routing No." = FIELD("Routing No."),
                                  "Operation No." = FIELD("Operation No."),
                                  "Spec ID" = field("Quality Spec ID");
                RunPageMode = View;
                ToolTip = 'View or edit information about quality measures that apply to operations that represent the standard task.';
            }
        }
        addafter("Quality Measures_Promoted")
        {
            actionref(QualitySpecDoc_Promoted; "Quality Spec Doc")
            {
            }
        }
    }
}
