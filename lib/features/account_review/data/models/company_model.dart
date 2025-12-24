class CompanyModel {
  final String coId;
  final String coName;
  final String coAdd1;
  final String? coAdd2;
  final String? coAdd3;
  final String? coAdd4;
  final String? coPer1; // Logo
  final String? coPer2;
  final String? coPer3;
  final String? coPer4;
  final String? coPer5;
  final String? coPer6;
  final String? coPer7;
  final String? coPer8;
  final String? coPer9;
  final String? coPer10;
  final String? coPer11;
  final String? coPer12;
  final String? coPer13;
  final String? coPer14;
  final String? coPer15;
  final String? coPer16;
  final String? coPer17;
  final String? coPer18;
  final String? coPer19;
  final String? coPer20;
  final String? coPer21;
  final String? coPer22;
  final String? coPer23;
  final String? coPer24;
  final String? coPer25;
  final String? coPer26;
  final String? coPer27;
  final String? coPer28;
  final String? coPer29;
  final String? coPer30;
  final String? coPer31;
  final String? coPer32;
  final String? coPer33;
  final String? coPer34;
  final String? coPer35;
  final String? coPer36;
  final String? coPer37;
  final String? coPer38;
  final String? coPer39;
  final String? coPer40;
  final String? coCst;
  final String? coIt;
  final String? coTel;
  final String? coPin;
  final String? coCity;
  final String? coTel1;
  final String? coFydt;
  final String? coEndt;
  final String? coDir;
  final String? coYear;
  final String? coDate;
  final String? coSymb;
  final String? coStrg;
  final String? coSbst;
  final String? coEmail;
  final String? coFdate;
  final String? coVal;
  final String? coFmil;
  final String? coDemo;
  final String? coAlias;
  final String? coO1prn;
  final String? coT1prn;
  final String? coR1prn;
  final String? coDes1; // Description/Status
  final String? m2Bt; // User account status (Active/Inactive)

  CompanyModel({
    required this.coId,
    required this.coName,
    required this.coAdd1,
    this.coAdd2,
    this.coAdd3,
    this.coAdd4,
    this.coPer1,
    this.coPer2,
    this.coPer3,
    this.coPer4,
    this.coPer5,
    this.coPer6,
    this.coPer7,
    this.coPer8,
    this.coPer9,
    this.coPer10,
    this.coPer11,
    this.coPer12,
    this.coPer13,
    this.coPer14,
    this.coPer15,
    this.coPer16,
    this.coPer17,
    this.coPer18,
    this.coPer19,
    this.coPer20,
    this.coPer21,
    this.coPer22,
    this.coPer23,
    this.coPer24,
    this.coPer25,
    this.coPer26,
    this.coPer27,
    this.coPer28,
    this.coPer29,
    this.coPer30,
    this.coPer31,
    this.coPer32,
    this.coPer33,
    this.coPer34,
    this.coPer35,
    this.coPer36,
    this.coPer37,
    this.coPer38,
    this.coPer39,
    this.coPer40,
    this.coCst,
    this.coIt,
    this.coTel,
    this.coPin,
    this.coCity,
    this.coTel1,
    this.coFydt,
    this.coEndt,
    this.coDir,
    this.coYear,
    this.coDate,
    this.coSymb,
    this.coStrg,
    this.coSbst,
    this.coEmail,
    this.coFdate,
    this.coVal,
    this.coFmil,
    this.coDemo,
    this.coAlias,
    this.coO1prn,
    this.coT1prn,
    this.coR1prn,
    this.coDes1,
    this.m2Bt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      coId: json['CO_Id']?.toString() ?? '',
      coName: json['CO_NAME']?.toString() ?? '',
      coAdd1: json['CO_ADD1']?.toString() ?? '',
      coAdd2: json['CO_ADD2']?.toString(),
      coAdd3: json['CO_ADD3']?.toString(),
      coAdd4: json['CO_ADD4']?.toString(),
      coPer1: json['CO_PER1']?.toString(),
      coPer2: json['CO_PER2']?.toString(),
      coPer3: json['CO_PER3']?.toString(),
      coPer4: json['CO_PER4']?.toString(),
      coPer5: json['CO_PER5']?.toString(),
      coPer6: json['CO_PER6']?.toString(),
      coPer7: json['CO_PER7']?.toString(),
      coPer8: json['CO_PER8']?.toString(),
      coPer9: json['CO_PER9']?.toString(),
      coPer10: json['CO_PER10']?.toString(),
      coPer11: json['CO_PER11']?.toString(),
      coPer12: json['CO_PER12']?.toString(),
      coPer13: json['CO_PER13']?.toString(),
      coPer14: json['CO_PER14']?.toString(),
      coPer15: json['CO_PER15']?.toString(),
      coPer16: json['CO_PER16']?.toString(),
      coPer17: json['CO_PER17']?.toString(),
      coPer18: json['CO_PER18']?.toString(),
      coPer19: json['CO_PER19']?.toString(),
      coPer20: json['CO_PER20']?.toString(),
      coPer21: json['CO_PER21']?.toString(),
      coPer22: json['CO_PER22']?.toString(),
      coPer23: json['CO_PER23']?.toString(),
      coPer24: json['CO_PER24']?.toString(),
      coPer25: json['CO_PER25']?.toString(),
      coPer26: json['CO_PER26']?.toString(),
      coPer27: json['CO_PER27']?.toString(),
      coPer28: json['CO_PER28']?.toString(),
      coPer29: json['CO_PER29']?.toString(),
      coPer30: json['CO_PER30']?.toString(),
      coPer31: json['CO_PER31']?.toString(),
      coPer32: json['CO_PER32']?.toString(),
      coPer33: json['CO_PER33']?.toString(),
      coPer34: json['CO_PER34']?.toString(),
      coPer35: json['CO_PER35']?.toString(),
      coPer36: json['CO_PER36']?.toString(),
      coPer37: json['CO_PER37']?.toString(),
      coPer38: json['CO_PER38']?.toString(),
      coPer39: json['CO_PER39']?.toString(),
      coPer40: json['CO_PER40']?.toString(),
      coCst: json['CO_CST']?.toString(),
      coIt: json['CO_IT']?.toString(),
      coTel: json['CO_TEL']?.toString(),
      coPin: json['CO_PIN']?.toString(),
      coCity: json['CO_CITY']?.toString(),
      coTel1: json['CO_TEL1']?.toString(),
      coFydt: json['CO_FYDT']?.toString(),
      coEndt: json['CO_ENDT']?.toString(),
      coDir: json['CO_DIR']?.toString(),
      coYear: json['CO_YEAR']?.toString(),
      coDate: json['CO_DATE']?.toString(),
      coSymb: json['CO_SYMB']?.toString(),
      coStrg: json['CO_STRG']?.toString(),
      coSbst: json['CO_SBST']?.toString(),
      coEmail: json['CO_EMAIL']?.toString(),
      coFdate: json['CO_FDATE']?.toString(),
      coVal: json['CO_VAL']?.toString(),
      coFmil: json['CO_FMIL']?.toString(),
      coDemo: json['CO_DEMO']?.toString(),
      coAlias: json['CO_ALIAS']?.toString(),
      coO1prn: json['CO_O1PRN']?.toString(),
      coT1prn: json['CO_T1PRN']?.toString(),
      coR1prn: json['CO_R1PRN']?.toString(),
      coDes1: json['CO_DES1']?.toString(),
      m2Bt: json['M2_BT']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CO_Id': coId,
      'CO_NAME': coName,
      'CO_ADD1': coAdd1,
      'CO_ADD2': coAdd2,
      'CO_ADD3': coAdd3,
      'CO_ADD4': coAdd4,
      'CO_PER1': coPer1,
      'CO_PER2': coPer2,
      'CO_PER3': coPer3,
      'CO_PER4': coPer4,
      'CO_PER5': coPer5,
      'CO_PER6': coPer6,
      'CO_PER7': coPer7,
      'CO_PER8': coPer8,
      'CO_PER9': coPer9,
      'CO_PER10': coPer10,
      'CO_PER11': coPer11,
      'CO_PER12': coPer12,
      'CO_PER13': coPer13,
      'CO_PER14': coPer14,
      'CO_PER15': coPer15,
      'CO_PER16': coPer16,
      'CO_PER17': coPer17,
      'CO_PER18': coPer18,
      'CO_PER19': coPer19,
      'CO_PER20': coPer20,
      'CO_PER21': coPer21,
      'CO_PER22': coPer22,
      'CO_PER23': coPer23,
      'CO_PER24': coPer24,
      'CO_PER25': coPer25,
      'CO_PER26': coPer26,
      'CO_PER27': coPer27,
      'CO_PER28': coPer28,
      'CO_PER29': coPer29,
      'CO_PER30': coPer30,
      'CO_PER31': coPer31,
      'CO_PER32': coPer32,
      'CO_PER33': coPer33,
      'CO_PER34': coPer34,
      'CO_PER35': coPer35,
      'CO_PER36': coPer36,
      'CO_PER37': coPer37,
      'CO_PER38': coPer38,
      'CO_PER39': coPer39,
      'CO_PER40': coPer40,
      'CO_CST': coCst,
      'CO_IT': coIt,
      'CO_TEL': coTel,
      'CO_PIN': coPin,
      'CO_CITY': coCity,
      'CO_TEL1': coTel1,
      'CO_FYDT': coFydt,
      'CO_ENDT': coEndt,
      'CO_DIR': coDir,
      'CO_YEAR': coYear,
      'CO_DATE': coDate,
      'CO_SYMB': coSymb,
      'CO_STRG': coStrg,
      'CO_SBST': coSbst,
      'CO_EMAIL': coEmail,
      'CO_FDATE': coFdate,
      'CO_VAL': coVal,
      'CO_FMIL': coFmil,
      'CO_DEMO': coDemo,
      'CO_ALIAS': coAlias,
      'CO_O1PRN': coO1prn,
      'CO_T1PRN': coT1prn,
      'CO_R1PRN': coR1prn,
      'CO_DES1': coDes1,
      'M2_BT': m2Bt,
    };
  }
}
