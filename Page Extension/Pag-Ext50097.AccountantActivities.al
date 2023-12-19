pageextension 50097 AccountantActivities extends "Accountant Activities"
{
    layout
    {
        addafter("Incoming Documents")
        {
            cuegroup("Document Captures")
            {
                Caption = 'Documents Captures';

                field("New Documents Capturing"; Rec."New Documents Capturing")
                {
                    Caption = 'New';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Documents Capturing field.';
                }
                field("Verified Documents Capturing"; Rec."Verified Documents Capturing")
                {
                    Caption = 'Verified';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Verified Documents Capturing field.';
                }
                field("Validated Documents Capturing"; Rec."Validated Documents Capturing")
                {
                    Caption = 'Validated';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Validated Documents Capturing field.';
                }
                field("Failed Documents Capturing"; Rec."Failed Documents Capturing")
                {
                    Caption = 'Failed';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Failed Documents Capturing field.';
                }
                field("Processed Documents Capturing"; Rec."Processed Documents Capturing")
                {
                    Caption = 'Created Invoices';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processed Documents Capturing field.';
                }
                field("Rejected Documents Capturing"; Rec."Rejected Documents Capturing")
                {
                    Caption = 'Rejected';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rejected Documents Capturing field.';
                }
                field("PO Invoices"; Rec."PO Invoices")
                {
                    Caption = 'PO Invoices';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Invoices Documents Capturing field.';
                }
            }
        }
    }
    // trigger OnOpenPage()
    // begin
    //     Rec.SetFilter("Status Date Filter", '=%1', WorkDate());
    // end;
}
