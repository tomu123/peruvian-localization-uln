codeunit 51017 "Amount in letters"
{
    trigger OnRun()
    begin
    end;

    var
        No_nuevo: Text[30];
        No_contar: Integer;
        No_buscarpunto: Integer;
        No_NuevoEntero: Text[30];
        HundMilion: Integer;
        TenMilion: Integer;
        UnitsMilion: Integer;
        HundThousands: Integer;
        TenThousands: Integer;
        UnitsThousands: Integer;
        Hundreds: Integer;
        Tens: Integer;
        Units: Integer;
        DecimalPlaces: Integer;
        DecimalText: array[2] of Text[80];
        DecimalString: Text[15];
        Decimals: Integer;
        Remainder: Integer;
        No_Decimal: Text[30];
        Text1100000: Label 'Total %1 Incl. VAT+EC';
        Text1100001: Label '%1 is too big to be text-formatted';
        Text1100002: Label 'CERO ';
        Text1100003: Label '<decimals>';
        Text1100004: Label 'CON ';
        Text1100005: Label 'MILLONES ';
        Text1100006: Label 'UN MILLÓN ';
        Text1100007: Label 'MIL        ';
        Text1100008: Label 'CIEN ';
        Text1100009: Label 'CIENTO ';
        Text1100010: Label 'DOSCIENTOS ';
        Text1100011: Label 'TRESCIENTOS ';
        Text1100012: Label 'CUATROCIENTOS ';
        Text1100013: Label 'QUINIENTOS ';
        Text1100014: Label 'SEISCIENTOS ';
        Text1100015: Label 'SETECIENTOS ';
        Text1100016: Label 'OCHOCIENTOS ';
        Text1100017: Label 'NOVECIENTOS ';
        Text1100018: Label 'DOSCIENTOS ';
        Text1100019: Label 'TRESCIENTOS ';
        Text1100020: Label 'CUATROCIENTOS ';
        Text1100021: Label 'QUINIENTOS ';
        Text1100022: Label 'SEISCIENTOS ';
        Text1100023: Label 'SETECIENTOS ';
        Text1100024: Label 'OCHOCIENTOS ';
        Text1100025: Label 'NOVECIENTOS ';
        Text1100026: Label 'DIEZ ';
        Text1100027: Label 'ONCE ';
        Text1100028: Label 'DOCE ';
        Text1100029: Label 'TRECE ';
        Text1100030: Label 'CATORCE ';
        Text1100031: Label 'QUINCE ';
        Text1100032: Label 'DIECI';
        Text1100033: Label 'VEINTE ';
        Text1100034: Label 'VEINTI';
        Text1100035: Label 'TREINTA ';
        Text1100036: Label 'TREINTA Y ';
        Text1100037: Label 'CUARENTA ';
        Text1100038: Label 'CUARENTA Y ';
        Text1100039: Label 'CINCUENTA ';
        Text1100040: Label 'CINCUENTA Y ';
        Text1100041: Label 'SESENTA ';
        Text1100042: Label 'SESENTA Y ';
        Text1100043: Label 'SETENTA ';
        Text1100044: Label 'SETENTA Y ';
        Text1100045: Label 'OCHENTA ';
        Text1100046: Label 'OCHENTA Y ';
        Text1100047: Label 'NOVENTA ';
        Text1100048: Label 'NOVENTA Y ';
        Text1100049: Label 'UN ';
        Text1100050: Label 'UNO ';
        Text1100051: Label 'DOS ';
        Text1100052: Label 'TRES ';
        Text1100053: Label 'CUATRO ';
        Text1100054: Label 'CINCO ';
        Text1100055: Label 'SEIS ';
        Text1100056: Label 'SIETE ';
        Text1100057: Label 'OCHO ';
        Text1100058: Label 'NUEVE ';
        Text1100059: Label ' CÉNTIMOS';
        Text1100060: Label ' CÉNTIMOS';
        Text1100061: Label 'MILESIMAS';
        Text1100062: Label 'DIEZMILESIMAS';
        Text1100063: Label ' CÉNTIMO';
        Text1100064: Label ' CÉNTIMO';
        Text1100065: Label 'MILESIMA';
        Text1100066: Label 'DIEZMILESIMA';
        Text1100067: Label '%1 \results in a written number which is too long.';
        Text1100068: Label '<UN MIL>';
        TextoPie1: Label 'ssssssssssssssssssss';

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal)
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin

        Clear(NoText);
        NoTextIndex := 1;

        No_nuevo := Format(No, 0, 2);
        No_contar := StrLen(No_nuevo);
        No_buscarpunto := StrPos(No_nuevo, '.');
        if (No_buscarpunto = 0) then begin
            No_buscarpunto := StrPos(No_nuevo, '.');
        end;
        if No_buscarpunto > 0 then begin
            No_NuevoEntero := CopyStr(No_nuevo, 1, No_buscarpunto - 1);
            Evaluate(No, No_NuevoEntero + '.00');
            No_Decimal := CopyStr(No_nuevo, No_buscarpunto + 1, (No_contar - No_buscarpunto));
            if StrLen(No_Decimal) = 1 then No_Decimal := No_Decimal + '0';
            No_Decimal := ' CON ' + No_Decimal + '/100';
        end
        else begin
            No_Decimal := ' CON 00/100';
        end;

        if No > 999999999 then
            Error(Text1100001, No);

        if Round(No, 1, '<') = 0 then
            AddToNoText(NoText, NoTextIndex, Text1100002);
        HundMilion := Round(No, 1, '<') div 100000000;
        Remainder := Round(No, 1, '<') mod 100000000;
        TenMilion := Remainder div 10000000;
        Remainder := Remainder mod 10000000;
        UnitsMilion := Remainder div 1000000;
        Remainder := Remainder mod 1000000;
        HundThousands := Remainder div 100000;
        Remainder := Remainder mod 100000;
        TenThousands := Remainder div 10000;
        Remainder := Remainder mod 10000;
        UnitsThousands := Remainder div 1000;
        Remainder := Remainder mod 1000;
        Hundreds := Remainder div 100;
        Remainder := Remainder mod 100;
        Tens := Remainder div 10;
        Units := Remainder mod 10;

        DecimalPlaces := StrLen(Format(No, 0, Text1100003));
        if DecimalPlaces > 0 then begin
            DecimalPlaces := DecimalPlaces - 1;
            Decimals := (No - Round(No, 1, '<')) * Power(10, DecimalPlaces);
            if DecimalPlaces = 1 then
                Decimals := Decimals * 10;
            DecimalString := TextNoDecimals(DecimalPlaces);

        end;
        AddToNoText(NoText, NoTextIndex, TextHundMilion(HundMilion, TenMilion, UnitsMilion, true));
        AddToNoText(NoText, NoTextIndex, TextTenUnitsMilion(HundMilion, TenMilion, UnitsMilion, true));
        AddToNoText(NoText, NoTextIndex, TextHundThousands(HundThousands, TenThousands, UnitsThousands, false));
        AddToNoText(NoText, NoTextIndex, TextTenUnitsThousands(HundThousands, TenThousands, UnitsThousands, false));
        AddToNoText(NoText, NoTextIndex, TextHundreds(Hundreds, Tens, Units, false));
        AddToNoText(NoText, NoTextIndex, TextTensUnits(Tens, Units, false));
        if DecimalPlaces > 0 then begin
            FormatNoText(DecimalText, Decimals);

            AddToNoText(
              NoText, NoTextIndex, Text1100004 + DecimalText[1] + DecimalString);
        end;
    end;

    procedure TextHundMilion(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        if Hundreds <> 0 then
            exit(TextHundreds(Hundreds, Ten, Units, true));
    end;

    procedure TextTenUnitsMilion(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        if (Hundreds <> 0) and (Ten = 0) and (Units = 0) then
            exit(Text1100005);
        if (Hundreds = 0) and (Ten = 0) and (Units = 1) then
            exit(Text1100006);
        if (Ten <> 0) or (Units <> 0) then
            exit(TextTensUnits(Ten, Units, Masc) + Text1100005);
    end;

    procedure TextHundThousands(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        if Hundreds <> 0 then
            exit(TextHundreds(Hundreds, Ten, Units, Masc))
    end;

    procedure TextTenUnitsThousands(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        if (Hundreds <> 0) and (Ten = 0) and (Units = 0) then
            exit(Text1100007 + ' ');
        if (Hundreds = 0) and (Ten = 0) and (Units = 1) then
            exit(Text1100007 + ' ');
        if (Ten <> 0) or (Units <> 0) then
            exit(TextTensUnits(Ten, Units, Masc) + Text1100007 + ' ');
    end;

    procedure TextHundreds(Hundreds: Integer; Tens: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        if Hundreds = 0 then
            exit('');
        if Masc then
            case Hundreds of
                1:
                    if (Tens = 0) and (Units = 0) then
                        exit(Text1100008)
                    else
                        exit(Text1100009);
                2:
                    exit(Text1100010);
                3:
                    exit(Text1100011);
                4:
                    exit(Text1100012);
                5:
                    exit(Text1100013);
                6:
                    exit(Text1100014);
                7:
                    exit(Text1100015);
                8:
                    exit(Text1100016);
                9:
                    exit(Text1100017);
            end
        else
            case Hundreds of
                1:
                    if (Tens = 0) and (Units = 0) then
                        exit(Text1100008)
                    else
                        exit(Text1100009);
                2:
                    exit(Text1100018);
                3:
                    exit(Text1100019);
                4:
                    exit(Text1100020);
                5:
                    exit(Text1100021);
                6:
                    exit(Text1100022);
                7:
                    exit(Text1100023);
                8:
                    exit(Text1100024);
                9:
                    exit(Text1100025);
            end;
    end;

    procedure TextTensUnits(Tens: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        case Tens of
            0:
                exit(TextUnits(Units, Masc));
            1:
                case Units of
                    0:
                        exit(Text1100026);
                    1:
                        exit(Text1100027);
                    2:
                        exit(Text1100028);
                    3:
                        exit(Text1100029);
                    4:
                        exit(Text1100030);
                    5:
                        exit(Text1100031);
                    else
                        exit(Text1100032 + TextUnits(Units, Masc));
                end;
            2:
                if Units = 0 then
                    exit(Text1100033)
                else
                    exit(Text1100034 + TextUnits(Units, Masc));
            3:
                if Units = 0 then
                    exit(Text1100035)
                else
                    exit(Text1100036 + TextUnits(Units, Masc));
            4:
                if Units = 0 then
                    exit(Text1100037)
                else
                    exit(Text1100038 + TextUnits(Units, Masc));
            5:
                if Units = 0 then
                    exit(Text1100039)
                else
                    exit(Text1100040 + TextUnits(Units, Masc));
            6:
                if Units = 0 then
                    exit(Text1100041)
                else
                    exit(Text1100042 + TextUnits(Units, Masc));
            7:
                if Units = 0 then
                    exit(Text1100043)
                else
                    exit(Text1100044 + TextUnits(Units, Masc));
            8:
                if Units = 0 then
                    exit(Text1100045)
                else
                    exit(Text1100046 + TextUnits(Units, Masc));
            9:
                if Units = 0 then
                    exit(Text1100047)
                else
                    exit(Text1100048 + TextUnits(Units, Masc));
        end;
    end;

    procedure TextUnits(Units: Integer; Masc: Boolean): Text[250]
    begin
        case Units of
            0:
                exit('');
            1:
                if Masc then
                    exit(Text1100049)
                else
                    exit(Text1100050);
            2:
                exit(Text1100051);
            3:
                exit(Text1100052);
            4:
                exit(Text1100053);
            5:
                exit(Text1100054);
            6:
                exit(Text1100055);
            7:
                exit(Text1100056);
            8:
                exit(Text1100057);
            9:
                exit(Text1100058);
        end;
    end;

    procedure TextNoDecimals(NoDecimals: Integer): Text[15]
    begin
        if Decimals > 1 then
            case NoDecimals of
                0:
                    exit('');
                1:
                    exit(Text1100059);
                2:
                    exit(Text1100060);
                3:
                    exit(Text1100061);
                4:
                    exit(Text1100062);
            end
        else
            case NoDecimals of
                0:
                    exit('');
                1:
                    exit(Text1100063);
                2:
                    exit(Text1100064);
                3:
                    exit(Text1100065);
                4:
                    exit(Text1100066);
            end;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; AddText: Text[80])
    begin
        while StrLen(NoText[NoTextIndex] + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text1100067, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + AddText, '<');
    end;

    procedure FormatNoText2(var No_Decimal: Text[80]; No: Decimal)
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin

        Clear(No_Decimal);
        NoTextIndex := 1;
        //////empezar

        No_nuevo := Format(No, 0, 2);
        No_contar := StrLen(No_nuevo);
        No_buscarpunto := StrPos(No_nuevo, '.');
        if (No_buscarpunto = 0) then begin
            No_buscarpunto := StrPos(No_nuevo, '.');
        end;
        if No_buscarpunto > 0 then begin
            No_NuevoEntero := CopyStr(No_nuevo, 1, No_buscarpunto - 1);
            Evaluate(No, No_NuevoEntero + '.00');
            No_Decimal := CopyStr(No_nuevo, No_buscarpunto + 1, (No_contar - No_buscarpunto));
            if StrLen(No_Decimal) = 1 then No_Decimal := No_Decimal + '0';
            No_Decimal := ' CON ' + No_Decimal + '/100';
        end
        else begin
            No_Decimal := ' CON 00/100';
        end;

        //////termina
    end;
}

