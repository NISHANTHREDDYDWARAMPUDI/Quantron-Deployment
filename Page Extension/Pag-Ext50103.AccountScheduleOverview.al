pageextension 50103 AccountScheduleOverviewEXt extends "Acc. Schedule Overview"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst("Export to Excel")
        {
            action(CustomAction)
            {
                ApplicationArea = All;
                Caption = 'Export Account Schedule To Excel ';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ExportAcc: Report ExportAccouScheduleToExcelNew;
                    FinancialReport: Record "Financial Report";
                begin
                    FinancialReport.Reset();
                    FinancialReport.SetRange(Name, Rec."Schedule Name");
                    if FinancialReport.FindFirst() then;
                    ExportAcc.SetOptions(Rec, FinancialReport."Financial Report Column Group", FinancialReport.UseAmountsInAddCurrency);
                    ExportAcc.Run();
                end;
            }
        }
    }

    var

        TempFinancialReport: Record "Financial Report" temporary;

}
