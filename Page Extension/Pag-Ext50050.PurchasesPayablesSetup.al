pageextension 50050 "Purchases&PayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group("Email Accounts")
            {
                Caption = 'Email Accounts';

                field("Purch./LogisticsTeam E-Mail"; Rec."Purch./LogisticsTeam E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase/LogisticsTeam E-Mail field.';
                }
                field("Purch./LogisticsTeam E-Mail CC"; Rec."Purch./LogisticsTeam E-Mail CC")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase/LogisticsTeam E-Mail CC field.';
                }
                field("Project Team E-Mail"; Rec."Project Team E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Project Team E-Mail field.';
                }
                field("Project Team E-Mail CC"; Rec."Project Team E-Mail CC")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Project Team E-Mail CC field.';
                }
                field("Document Capturing Email"; Rec."Document Capturing Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Capturing Error log Email field.';
                }
                field("Quality Check Incoming Email"; Rec."Quality Check Incoming Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quality Check Incoming Email field.';
                }
            }
            group("Material Transfer")
            {
                field("Reclass Journal Template"; Rec."Reclass Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reclass Journal Template field.';
                }
                field("Reclass Journal Batch"; Rec."Reclass Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reclass Journal Batch field.';
                }
            }
            group(PhysicalInventory)
            {
                Caption = 'Physical Inventory';
                field("Def. Phy. Inv Template"; Rec."Def. Phy. Inv Template")
                {
                    ApplicationArea = All;
                }
                field("Def. Phy. Inv Batch"; Rec."Def. Phy. Inv Batch")
                {
                    ApplicationArea = All;
                }
                field("Phy. Inv Logistic Email"; Rec."Phy. Inv Logistic Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Physical Inventory Logistic Email field.';
                }
            }
        }
        addlast("Number Series")
        {
            field("Document Capturing No."; Rec."Document Capturing No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Capturing No. field.';
            }
        }
    }
}
