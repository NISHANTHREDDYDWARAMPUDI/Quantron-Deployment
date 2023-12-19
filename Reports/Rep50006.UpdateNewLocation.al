report 50006 UpdateNewLocation
{
    ApplicationArea = All;
    Caption = 'UpdateNewLocation';
    Permissions = tabledata "Purch. Rcpt. Line" = RIMD;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(PurchRcptLine; "Purch. Rcpt. Line")
        {
            trigger OnAfterGetRecord()
            var
                ConfirmTxt: Label 'Do you want to change the new location from %1 to %2.?';
                WMSManagement: Codeunit "WMS Management";
                LoopErr: Label 'Multiple Line Loop. Please contact administrator';
            begin
                if PurchRcptLine.Count <> 1 then
                    Error(LoopErr);

                if NewLocationGVar <> PurchRcptLine."New Location Code" then begin
                    if not Confirm(StrSubstNo(ConfirmTxt, PurchRcptLine."New Location Code", NewLocationGVar)) then
                        exit;
                end;
                PurchRcptLine."New Location Code" := NewLocationGVar;
                PurchRcptLine."New Bin Code" := NewBinCode;
                if ("New Location Code" <> '') and (PurchRcptLine."No." <> '') and (PurchRcptLine."New Bin Code" = '') then begin
                    GetLocation("New Location Code");
                    GetItem();
                    if IsDefaultBin() and Item.IsInventoriableType() then
                        WMSManagement.GetDefaultBin("No.", "Variant Code", "New Location Code", "New Bin Code")
                end;
                PurchRcptLine.Modify();
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Line No.", LineNo);
            end;
        }
    }
    var
        NewLocationGVar: code[20];
        NewBinCode: code[20];
        Location: Record Location;
        Item: Record Item;
        LineNo: Integer;

    procedure SetNewBin(NewBinPar: Code[20])
    begin
        NewBinCode := NewBinPar;
    end;

    procedure SetNewLocation(NewLocationPar: Code[20])
    begin
        NewLocationGVar := NewLocationPar;
    end;

    procedure SetLineNo(LineNoVar: Integer)
    begin
        LineNo := LineNoVar;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure GetItem()
    begin
        if Item."No." <> PurchRcptLine."No." then
            Item.Get(PurchRcptLine."No.");
    end;

    local procedure IsDefaultBin() Result: Boolean
    begin
        Result := Location."Bin Mandatory" and not Location."Directed Put-away and Pick";
    end;
}
