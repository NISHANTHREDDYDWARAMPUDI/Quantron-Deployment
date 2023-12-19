report 50007 "Auto Create Phy. Inv. Journal"
{
    ApplicationArea = All;
    Caption = 'Auto Create Physical Inv. Journal';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(bin; bin)
        {
            RequestFilterFields = "Location Code", Code;
            trigger OnPreDataItem()
            var
                Calender: Record Date;
            begin
                Calender.Reset();
                Calender.SetRange("Period Type", Calender."Period Type"::Week);
                Calender.SetFilter("Period Start", '<=%1', WorkDate());
                Calender.SetFilter("Period End", '>=%1', WorkDate());
                Calender.FindFirst();
                SetRange("Week No.", Calender."Period No.");
            end;

            trigger OnAfterGetRecord()
            var
                ItemRec: Record Item;
                ItemJnlBatch: Record "Item Journal Batch";
                ItemJnlLine: Record "Item Journal Line";
                PhysInvtCountPeriod: Record "Phys. Invt. Counting Period";
                CalculateInventory: Report "Calculate Inventory";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                PurchSetup.Get();
                PurchSetup.TestField("Def. Phy. Inv Template");
                PurchSetup.TestField("Def. Phy. Inv Batch");
                PurchSetup.TestField("Phy. Inv Logistic Email");
                ItemJnlBatch.Get(PurchSetup."Reclass Journal Template", PurchSetup."Reclass Journal Batch");
                ItemJnlBatch.TestField("No. Series");

                ItemJnlLine.Reset();
                ItemJnlLine.Init();
                ItemJnlLine."Journal Template Name" := PurchSetup."Def. Phy. Inv Template";
                ItemJnlLine."Journal Batch Name" := PurchSetup."Def. Phy. Inv Batch";

                ItemRec.Reset;
                ItemRec.SetFilter("Location Filter", bin."Location Code");
                ItemRec.SetFilter("Bin Filter", bin.Code);
                CalculateInventory.SetHideValidationDialog(true);
                CalculateInventory.InitializeRequest(WorkDate(), NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series", WorkDate(), false), false, false);
                CalculateInventory.SetItemJnlLine(ItemJnlLine);
                CalculateInventory.SetTableView(ItemRec);
                CalculateInventory.UseRequestPage(false);
                CalculateInventory.Run();

                PhysInvtCountPeriod.Get("Phys Invt Counting Period Code");
                PhysInvtCountPeriod.TestField("Count Frequency per Year");
                Validate("Last Counting Date", WorkDate());
                Modify();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }
    var
        PurchSetup: Record "Purchases & Payables Setup";

    trigger OnPostReport()
    var
        SendEmail: Codeunit "Send Email Stream";
    begin
        SendEmail.ReportSendMailPhyInvAttachment(PurchSetup."Phy. Inv Logistic Email");
    end;

    procedure CalcNextCountingDate(LastDate: Date; var NextCountingDate: Date; CountFrequency: Integer)
    var
        Calender: Record Date;
        PeriodLength: DateFormula;
        MonthDate: Date;
        WeekEndDate: Date;
        WeekStartDate: Date;
        Days: Decimal;
        CurrentPeriodNo: Integer;
        NoOfMonths: Integer;
    begin
        if LastDate = 0D then
            exit;

        case CountFrequency of
            1, 2, 3, 4, 6, 12:
                begin
                    if CountFrequency <> 0 then
                        NoOfMonths := 12 / CountFrequency;
                    Evaluate(PeriodLength, Format(NoOfMonths) + 'M');
                    MonthDate := CalcDate(PeriodLength, LastDate);
                end;
        end;

        if MonthDate = 0D then
            MonthDate := WorkDate();

        //CurrentPeriodNo
        Calender.Reset();
        Calender.SetRange("Period Type", Calender."Period Type"::Date);
        Calender.SetRange("Period Start", LastDate);
        Calender.FindFirst();
        CurrentPeriodNo := Calender."Period No.";

        //CurrentWeekDates
        Calender.Reset();
        Calender.SetRange("Period Type", Calender."Period Type"::Week);
        Calender.SetFilter("Period Start", '<=%1', MonthDate);
        Calender.SetFilter("Period End", '>=%1', MonthDate);
        Calender.FindFirst();
        WeekStartDate := Calender."Period Start";
        WeekEndDate := Calender."Period End";

        //NextCountingDate
        Calender.Reset();
        Calender.SetRange("Period Type", Calender."Period Type"::Date);
        Calender.SetRange("Period Start", WeekStartDate, WeekEndDate);
        Calender.SetRange("Period No.", CurrentPeriodNo);
        Calender.FindFirst();

        NextCountingDate := Calender."Period Start";
    end;
}
