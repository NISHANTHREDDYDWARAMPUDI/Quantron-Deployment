pageextension 50111 PostedWareHouseRecepitLinesExt extends "Posted Whse. Receipt"
{
    layout
    {

    }

    actions
    {

        addafter("&Print")
        {

            action(PrintItemLabel)
            {
                ApplicationArea = All;
                Caption = 'Print Label';
                Image = Print;

                trigger OnAction()
                var

                    WarehouserecepitLines: Record "Posted Whse. Receipt Line";
                begin
                    WarehouserecepitLines.Reset();
                    WarehouserecepitLines.SetRange("No.", rec."No.");

                    Report.RunModal(Report::"Item Label", true, false, WarehouserecepitLines);


                end;


            }

        }
    }

    var
        myInt: Integer;
}