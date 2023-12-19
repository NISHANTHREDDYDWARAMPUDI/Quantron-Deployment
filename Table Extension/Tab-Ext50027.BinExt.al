tableextension 50027 BinExt extends Bin
{
    fields
    {
        field(50000; "Phys Invt Counting Period Code"; Code[10])
        {
            Caption = 'Phys Invt Counting Period Code';
            TableRelation = "Phys. Invt. Counting Period";
        }
        field(50001; "Last Counting Date"; Date)
        {
            Caption = 'Last Counting Date';
            trigger OnValidate()
            var
                PhysInvtCountPeriod: Record "Phys. Invt. Counting Period";
                AutoCreatePhy: Report "Auto Create Phy. Inv. Journal";
                Text7380: Label 'If you change the %1 and %2 are calculated.\Do you still want to change the %1?', Comment = 'If you change the Phys Invt Counting Period Code, the Next Counting Start Date and Next Counting End Date are calculated.\Do you still want to change the Phys Invt Counting Period Code?';
                Text7381: Label 'Cancelled.';
            begin
                if "Phys Invt Counting Period Code" = '' then
                    exit;
                if xRec."Phys Invt Counting Period Code" <> '' then
                    if CurrFieldNo <> 0 then
                        if not Confirm(
                             Text7380,
                             false,
                             FieldCaption("Phys Invt Counting Period Code"),
                             FieldCaption("Next Counting Date"))
                        then
                            Error(Text7381);
                if "Last Counting Date" = 0D then
                    "Last Counting Date" := WorkDate();
                PhysInvtCountPeriod.Get("Phys Invt Counting Period Code");
                PhysInvtCountPeriod.TestField("Count Frequency per Year");
                if CurrFieldNo = 0 then
                    AutoCreatePhy.CalcNextCountingDate(WorkDate(), "Next Counting Date", PhysInvtCountPeriod."Count Frequency per Year");
            end;
        }
        field(50002; "Next Counting Date"; Date)
        {
            Caption = 'Next Counting Date';
            Editable = false;
        }
        field(50003; "Week No."; Integer)
        {
            Caption = 'Week No.';
            DataClassification = ToBeClassified;
        }
    }
    procedure AssignWeekNo()
    var
        Calender: Record Date;
        Window: Dialog;
        Bins: Record Bin;
        TotalBins: Integer;
        BinsPerWeek: Integer;
        BinsCount: Integer;
        YearStart: Date;
        YearEnd: Date;
        ExitLoop: Boolean;
    begin
        Window.Open('Update Week Nos..........\ Updating Current Week : #1####### \ Total Weeks : 52');
        Bins.Reset();
        Bins.SetRange("Last Counting Date", 0D);
        Bins.SetRange("Next Counting Date", 0D);
        if Bins.FindSet() then
            if Bins.Count = 0 then
                exit
            else
                TotalBins := Bins.Count;

        BinsPerWeek := Round(TotalBins / 50, 1, '>');

        YearStart := CalcDate('-CY', WorkDate());
        YearEnd := CalcDate('CY', WorkDate());

        Calender.Reset();
        Calender.SetRange("Period Type", Calender."Period Type"::Week);
        Calender.SetFilter("Period Start", '%1..%2', YearStart, YearEnd);
        if Calender.FindSet() then
            repeat
                Window.Update(1, Calender."Period No.");
                Clear(BinsCount);
                Bins.Reset();
                Bins.SetRange("Last Counting Date", 0D);
                Bins.SetRange("Next Counting Date", 0D);
                if Bins.FindSet() then
                    repeat
                        BinsCount += 1;
                        Bins."Week No." := Calender."Period No.";
                        Bins."Last Counting Date" := Calender."Period Start";
                        Bins.Modify();
                    until (Bins.Next() = 0) or (BinsPerWeek = BinsCount)
                else
                    ExitLoop := true;
            until (Calender.Next() = 0) or ExitLoop;
        Window.Close();
    end;
}
