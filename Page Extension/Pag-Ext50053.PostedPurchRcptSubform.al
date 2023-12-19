pageextension 50053 PostedPurchRcptSubform extends "Posted Purchase Rcpt. Subform"
{
    Editable = true;
    layout
    {
        addbefore("Location Code")
        {
            field("Quality Check"; Rec."Quality Check")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Check field.';
            }
            field("Quality Spec ID"; Rec."Quality Spec ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Spec ID field.';
            }
            field("Quality Check Completed"; Rec."Quality Check Completed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Check Completed field.';
            }
        }
        addafter("Location Code")
        {
            field(NewLocationCode; NewLocationCode)
            {
                Caption = 'New Location Code';
                ApplicationArea = all;
                TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
                Editable = Rec.Type = Rec.Type::Item;
                trigger OnValidate()
                var
                    UpdateNewLoc: Report UpdateNewLocation;
                begin
                    UpdateNewLoc.SetNewLocation(NewLocationCode);
                    UpdateNewLoc.SetNewBin(NewBinCode);
                    UpdateNewLoc.SetLineNo(Rec."Line No.");
                    UpdateNewLoc.SetTableView(Rec);
                    UpdateNewLoc.Run();
                    CurrPage.Update(true);
                end;
            }
            field(NewBinCode; NewBinCode)
            {
                Caption = 'New Bin Code';
                ApplicationArea = all;
                Editable = Rec.Type = Rec.Type::Item;
                TableRelation = Bin.Code WHERE("Location Code" = FIELD("New Location Code"),
                                            "Item Filter" = FIELD("No."),
                                            "Variant Filter" = FIELD("Variant Code"));

                trigger OnValidate()
                var
                    UpdateNewLoc: Report UpdateNewLocation;
                begin
                    UpdateNewLoc.SetNewLocation(NewLocationCode);
                    UpdateNewLoc.SetNewBin(NewBinCode);
                    UpdateNewLoc.SetLineNo(Rec."Line No.");
                    UpdateNewLoc.SetTableView(Rec);
                    UpdateNewLoc.Run();
                    CurrPage.Update(true);
                end;
            }
            field("New Location Code"; Rec."New Location Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the New Location Code field.';
            }
            field("New Bin Code"; Rec."New Bin Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the New Bin Code field.';
            }
        }
        addafter(Description)
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Undo Receipt")
        {
            action("Quality Spec Doc")
            {
                ApplicationArea = all;
                Caption = 'Quality Spec Document';
                Image = TaskQualityMeasure;
                RunObject = Page "Purch. Rcpt QS";
                Enabled = Rec.Type = Rec.Type::Item;
                RunPageLink = "Document No." = field("Document No."), "Rcpt. Line No." = field("Line No.");
                RunPageMode = View;
                ToolTip = 'View or edit information about quality measures that apply to operations that represent the standard task.';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        NewLocationCode := Rec."New Location Code";
        NewBinCode := Rec."New Bin Code";
    end;

    var
        NewLocationCode: Code[20];
        NewBinCode: Code[20];
}
