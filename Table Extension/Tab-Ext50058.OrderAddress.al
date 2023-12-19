tableextension 50058 OrderAddressExt extends "Order Address"
{
    fields
    {
        field(50001; "VAT Registration No."; Text[20])
        {

            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                if IsHandled then
                    exit;
                "VAT Registration No." := UpperCase("VAT Registration No.");
                if "VAT Registration No." <> xRec."VAT Registration No." then
                    VATRegistrationValidation();
            end;
        }

    }

    procedure VATRegistrationValidation()
    var
        VATRegistrationLog: Record "VAT Registration Log";
        VATRegistrationNoFormat: Record "VAT Registration No. Format";
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        ResultRecordRef: RecordRef;
        ApplicableCountryCode: Code[10];
        IsHandled: Boolean;
        LogNotVerified: Boolean;
    begin
        IsHandled := false;
        //OnBeforeVATRegistrationValidation(Rec, IsHandled, CurrFieldNo);
        if IsHandled then
            exit;

        if not VATRegistrationNoFormat.Test("VAT Registration No.", "Country/Region Code", "Vendor No.", DATABASE::"Order Address") then
            exit;

        LogNotVerified := true;
        if ("Country/Region Code" <> '') or (VATRegistrationNoFormat."Country/Region Code" <> '') then begin
            ApplicableCountryCode := "Country/Region Code";
            if ApplicableCountryCode = '' then
                ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
            if VATRegNoSrvConfig.VATRegNoSrvIsEnabled() then begin
                LogNotVerified := false;
                VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef, Rec, "Vendor No.", VATRegistrationLog."Account Type"::"Order Address".AsInteger(), ApplicableCountryCode);
                ResultRecordRef.SetTable(Rec);
            end;
        end;

        if LogNotVerified then
            LogOrderAddress(Rec);

    end;

    procedure LogOrderAddress(OrderAddress: Record "Order Address")
    var
        VATRegistrationLog: Record "VAT Registration Log";
        CountryCode: Code[10];
    begin
        CountryCode := GetCountryCode(OrderAddress."Country/Region Code");
        if not IsEUCountry(CountryCode) then
            exit;

        InsertVATRegistrationLog(
          OrderAddress."VAT Registration No.", CountryCode, VATRegistrationLog."Account Type"::"Order Address", OrderAddress."Vendor No.");
    end;

    local procedure GetCountryCode(CountryCode: Code[10]): Code[10]
    var
        CompanyInformation: Record "Company Information";
    begin
        if CountryCode <> '' then
            exit(CountryCode);

        CompanyInformation.Get();
        exit(CompanyInformation."Country/Region Code");
    end;

    local procedure IsEUCountry(CountryCode: Code[10]): Boolean
    var
        CountryRegion: Record "Country/Region";
        CompanyInformation: Record "Company Information";
    begin
        if (CountryCode = '') and CompanyInformation.Get() then
            CountryCode := CompanyInformation."Country/Region Code";

        if CountryCode <> '' then
            if CountryRegion.Get(CountryCode) then
                exit(CountryRegion."EU Country/Region Code" <> '');
        exit(false);
    end;

    local procedure InsertVATRegistrationLog(VATRegNo: Text[20]; CountryCode: Code[10]; AccountType: Enum "VAT Registration Log Account Type"; AccountNo: Code[20])
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        VATRegistrationLog.Init();
        VATRegistrationLog."VAT Registration No." := VATRegNo;
        VATRegistrationLog."Country/Region Code" := CountryCode;
        VATRegistrationLog."Account Type" := AccountType;
        VATRegistrationLog."Account No." := AccountNo;
        VATRegistrationLog."User ID" := CopyStr(UserId(), 1, MaxStrLen(VATRegistrationLog."User ID"));
        VATRegistrationLog.Insert(true);

    end;

}