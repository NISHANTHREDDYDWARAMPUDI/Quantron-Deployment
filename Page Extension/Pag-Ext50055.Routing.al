pageextension 50055 Routing extends Routing
{
    layout
    {
        addbefore(Control1900383207)
        {
            part("Attached Documents"; "Document Attachment Fact_B2B")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Provider = RoutingLine;
                SubPageLink = "Table ID" = CONST(Database::"Work Center"),
                              "No." = FIELD("Work Center No.");
            }
        }
    }
    actions
    {
        addafter("Copy &Routing")
        {
            action("Refresh &WorkInstruction")
            {
                ApplicationArea = all;
                Caption = 'Refresh &Work Instruction';
                Ellipsis = true;
                Image = Copy;
                ToolTip = 'Refresh an existing routing.';

                trigger OnAction()
                var
                    RtngLine: Record "Routing Line";
                    WorkCenter: Record "Work Center";
                    ConfirmTxt: Label 'Do you want to update the work instructions.?';
                begin
                    if not Confirm(ConfirmTxt, true) then
                        exit;
                    RtngLine.Reset();
                    RtngLine.SetCurrentKey("Routing No.", "Version Code", "Operation No.");
                    RtngLine.SetRange("Routing No.", Rec."No.");
                    if RtngLine.FindSet() then
                        repeat
                            if WorkCenter.Get(RtngLine."Work Center No.") then
                                if RtngLine."Work Instruction" <> WorkCenter."Work Instruction" then begin
                                    RtngLine."Work Instruction" := WorkCenter."Work Instruction";
                                    RtngLine.Modify(true);
                                end;
                        until RtngLine.Next() = 0;
                end;
            }
        }
        addafter("Copy &Routing_Promoted")
        {
            actionref("Refresh_WorkInstruction"; "Refresh &WorkInstruction")
            {
            }
        }
    }
}
