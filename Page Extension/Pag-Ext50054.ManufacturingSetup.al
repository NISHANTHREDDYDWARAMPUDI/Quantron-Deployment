pageextension 50054 ManufacturingSetup extends "Manufacturing Setup"
{
    layout
    {
        addafter("Routing Nos.")
        {
            field("Quality Spec Nos."; Rec."Quality Spec Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Spec Nos. field.';
            }
        }
        addafter(Planning)
        {
            group("Email Accounts")
            {
                Caption = 'Email Accounts';

                field("Sales Team Email"; Rec."Sales Team Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Team Email field.';
                }
                field("Account Team Email"; Rec."Account Team Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Team Email field.';
                }
            }
            group("Internal Shipment")
            {
                Caption = 'Internal Shipment Details';

                field("Inter Ship Transfer From"; Rec."Inter Ship Transfer From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal Shipment Transfer From field.';
                }
                field("Inter Ship Transfer To"; Rec."Inter Ship Transfer To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal Shipment Transfer To field.';
                }
                field("Int Ship Cust No."; Rec."Int Ship Cust No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal Shipment Customer No. field.';
                }
            }
            group("Pick List")
            {
                Caption = 'Pick List Transfer Material';

                field("Def. Pick List Transfer From"; Rec."Def. Pick List Transfer From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Pick List Transfer From field.';
                }
                field("Def. Pick List Bin Code"; Rec."Def. Pick List Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Pick List Transfer From field.';
                }
            }
        }
    }

}
