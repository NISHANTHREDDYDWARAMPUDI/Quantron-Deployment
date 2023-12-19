page 50016 "Physical Inventory Bin Setup"
{
    ApplicationArea = All;
    Caption = 'Physical Inventory Bin Setup';
    PageType = List;
    SourceTable = Bin;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the location from which you opened the Bins window.';
                }
                field("Code"; Rec."Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies a code that uniquely describes the bin.';
                }
                field("Phys Invt Counting Period Code"; Rec."Phys Invt Counting Period Code")
                {
                    ToolTip = 'Specifies the value of the Phys Invt Counting Period Code field.';
                }
                field("Week No."; Rec."Week No.")
                {
                    ToolTip = 'Specifies the value of the Week No. field.';
                }
                field("Last Counting Date"; Rec."Last Counting Date")
                {
                    ToolTip = 'Specifies the value of the Last Counting Date field.';
                }
                field("Next Counting Date"; Rec."Next Counting Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Next Counting Date field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Assign Week Nos")
            {
                Caption = 'Assign Week Nos';
                Image = PutAwayWorksheet;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ConfirmLbl: Label 'Do you want to assign the week nos.?';
                begin
                    if not Confirm(ConfirmLbl) then
                        exit;
                    Rec.AssignWeekNo();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';
                actionref(AssignWeekNo; "Assign Week Nos")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Week No.");
    end;
}
