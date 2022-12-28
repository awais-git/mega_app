// To parse this JSON data, do
//
//     final paymentmodel = paymentmodelFromJson(jsonString);

import 'dart:convert';

Paymentmodel paymentmodelFromJson(String str) => Paymentmodel.fromJson(json.decode(str));

String paymentmodelToJson(Paymentmodel data) => json.encode(data.toJson());

class Paymentmodel {
    Paymentmodel({
        this.links,
        this.clientReferenceInformation,
        this.consumerAuthenticationInformation,
        this.id,
        this.orderInformation,
        this.paymentAccountInformation,
        this.paymentInformation,
        this.processorInformation,
        this.reconciliationId,
        this.riskInformation,
        this.status,
        this.submitTimeUtc,
    });

    Links links;
    ClientReferenceInformation clientReferenceInformation;
    ConsumerAuthenticationInformation consumerAuthenticationInformation;
    String id;
    OrderInformation orderInformation;
    PaymentAccountInformation paymentAccountInformation;
    PaymentInformation paymentInformation;
    ProcessorInformation processorInformation;
    String reconciliationId;
    RiskInformation riskInformation;
    String status;
    DateTime submitTimeUtc;

    factory Paymentmodel.fromJson(Map<String, dynamic> json) => Paymentmodel(
        links: Links.fromJson(json["_links"]),
        clientReferenceInformation: ClientReferenceInformation.fromJson(json["clientReferenceInformation"]),
        consumerAuthenticationInformation: ConsumerAuthenticationInformation.fromJson(json["consumerAuthenticationInformation"]),
        id: json["id"],
        orderInformation: OrderInformation.fromJson(json["orderInformation"]),
        paymentAccountInformation: PaymentAccountInformation.fromJson(json["paymentAccountInformation"]),
        paymentInformation: PaymentInformation.fromJson(json["paymentInformation"]),
        processorInformation: ProcessorInformation.fromJson(json["processorInformation"]),
        reconciliationId: json["reconciliationId"],
        riskInformation: RiskInformation.fromJson(json["riskInformation"]),
        status: json["status"],
        submitTimeUtc: DateTime.parse(json["submitTimeUtc"]),
    );

    Map<String, dynamic> toJson() => {
        "_links": links.toJson(),
        "clientReferenceInformation": clientReferenceInformation.toJson(),
        "consumerAuthenticationInformation": consumerAuthenticationInformation.toJson(),
        "id": id,
        "orderInformation": orderInformation.toJson(),
        "paymentAccountInformation": paymentAccountInformation.toJson(),
        "paymentInformation": paymentInformation.toJson(),
        "processorInformation": processorInformation.toJson(),
        "reconciliationId": reconciliationId,
        "riskInformation": riskInformation.toJson(),
        "status": status,
        "submitTimeUtc": submitTimeUtc.toIso8601String(),
    };
}

class ClientReferenceInformation {
    ClientReferenceInformation({
        this.code,
    });

    String code;

    factory ClientReferenceInformation.fromJson(Map<String, dynamic> json) => ClientReferenceInformation(
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
    };
}

class ConsumerAuthenticationInformation {
    ConsumerAuthenticationInformation({
        this.token,
    });

    String token;

    factory ConsumerAuthenticationInformation.fromJson(Map<String, dynamic> json) => ConsumerAuthenticationInformation(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}

class Links {
    Links({
        this.linksVoid,
        this.self,
    });

    Self linksVoid;
    Self self;

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        linksVoid: Self.fromJson(json["void"]),
        self: Self.fromJson(json["self"]),
    );

    Map<String, dynamic> toJson() => {
        "void": linksVoid.toJson(),
        "self": self.toJson(),
    };
}

class Self {
    Self({
        this.method,
        this.href,
    });

    String method;
    String href;

    factory Self.fromJson(Map<String, dynamic> json) => Self(
        method: json["method"],
        href: json["href"],
    );

    Map<String, dynamic> toJson() => {
        "method": method,
        "href": href,
    };
}

class OrderInformation {
    OrderInformation({
        this.amountDetails,
    });

    AmountDetails amountDetails;

    factory OrderInformation.fromJson(Map<String, dynamic> json) => OrderInformation(
        amountDetails: AmountDetails.fromJson(json["amountDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "amountDetails": amountDetails.toJson(),
    };
}

class AmountDetails {
    AmountDetails({
        this.totalAmount,
        this.authorizedAmount,
        this.currency,
    });

    String totalAmount;
    String authorizedAmount;
    String currency;

    factory AmountDetails.fromJson(Map<String, dynamic> json) => AmountDetails(
        totalAmount: json["totalAmount"],
        authorizedAmount: json["authorizedAmount"],
        currency: json["currency"],
    );

    Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "authorizedAmount": authorizedAmount,
        "currency": currency,
    };
}

class PaymentAccountInformation {
    PaymentAccountInformation({
        this.card,
    });

    Card card;

    factory PaymentAccountInformation.fromJson(Map<String, dynamic> json) => PaymentAccountInformation(
        card: Card.fromJson(json["card"]),
    );

    Map<String, dynamic> toJson() => {
        "card": card.toJson(),
    };
}

class Card {
    Card({
        this.type,
    });

    String type;

    factory Card.fromJson(Map<String, dynamic> json) => Card(
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
    };
}

class PaymentInformation {
    PaymentInformation({
        this.tokenizedCard,
        this.scheme,
        this.bin,
        this.accountType,
        this.issuer,
        this.card,
        this.binCountry,
    });

    Card tokenizedCard;
    String scheme;
    String bin;
    String accountType;
    String issuer;
    Card card;
    String binCountry;

    factory PaymentInformation.fromJson(Map<String, dynamic> json) => PaymentInformation(
        tokenizedCard: Card.fromJson(json["tokenizedCard"]),
        scheme: json["scheme"],
        bin: json["bin"],
        accountType: json["accountType"],
        issuer: json["issuer"],
        card: Card.fromJson(json["card"]),
        binCountry: json["binCountry"],
    );

    Map<String, dynamic> toJson() => {
        "tokenizedCard": tokenizedCard.toJson(),
        "scheme": scheme,
        "bin": bin,
        "accountType": accountType,
        "issuer": issuer,
        "card": card.toJson(),
        "binCountry": binCountry,
    };
}

class ProcessorInformation {
    ProcessorInformation({
        this.systemTraceAuditNumber,
        this.approvalCode,
        this.cardVerification,
        this.merchantAdvice,
        this.responseDetails,
        this.networkTransactionId,
        this.retrievalReferenceNumber,
        this.consumerAuthenticationResponse,
        this.transactionId,
        this.responseCode,
        this.avs,
    });

    String systemTraceAuditNumber;
    String approvalCode;
    CardVerification cardVerification;
    Avs merchantAdvice;
    String responseDetails;
    String networkTransactionId;
    String retrievalReferenceNumber;
    Avs consumerAuthenticationResponse;
    String transactionId;
    String responseCode;
    Avs avs;

    factory ProcessorInformation.fromJson(Map<String, dynamic> json) => ProcessorInformation(
        systemTraceAuditNumber: json["systemTraceAuditNumber"],
        approvalCode: json["approvalCode"],
        cardVerification: CardVerification.fromJson(json["cardVerification"]),
        merchantAdvice: Avs.fromJson(json["merchantAdvice"]),
        responseDetails: json["responseDetails"],
        networkTransactionId: json["networkTransactionId"],
        retrievalReferenceNumber: json["retrievalReferenceNumber"],
        consumerAuthenticationResponse: Avs.fromJson(json["consumerAuthenticationResponse"]),
        transactionId: json["transactionId"],
        responseCode: json["responseCode"],
        avs: Avs.fromJson(json["avs"]),
    );

    Map<String, dynamic> toJson() => {
        "systemTraceAuditNumber": systemTraceAuditNumber,
        "approvalCode": approvalCode,
        "cardVerification": cardVerification.toJson(),
        "merchantAdvice": merchantAdvice.toJson(),
        "responseDetails": responseDetails,
        "networkTransactionId": networkTransactionId,
        "retrievalReferenceNumber": retrievalReferenceNumber,
        "consumerAuthenticationResponse": consumerAuthenticationResponse.toJson(),
        "transactionId": transactionId,
        "responseCode": responseCode,
        "avs": avs.toJson(),
    };
}

class Avs {
    Avs({
        this.code,
        this.codeRaw,
    });

    String code;
    String codeRaw;

    factory Avs.fromJson(Map<String, dynamic> json) => Avs(
        code: json["code"],
        codeRaw: json["codeRaw"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "codeRaw": codeRaw,
    };
}

class CardVerification {
    CardVerification({
        this.resultCodeRaw,
        this.resultCode,
    });

    String resultCodeRaw;
    String resultCode;

    factory CardVerification.fromJson(Map<String, dynamic> json) => CardVerification(
        resultCodeRaw: json["resultCodeRaw"],
        resultCode: json["resultCode"],
    );

    Map<String, dynamic> toJson() => {
        "resultCodeRaw": resultCodeRaw,
        "resultCode": resultCode,
    };
}

class RiskInformation {
    RiskInformation({
        this.localTime,
        this.score,
        this.infoCodes,
        this.profile,
        this.casePriority,
    });

    String localTime;
    Score score;
    InfoCodes infoCodes;
    Profile profile;
    String casePriority;

    factory RiskInformation.fromJson(Map<String, dynamic> json) => RiskInformation(
        localTime: json["localTime"],
        score: Score.fromJson(json["score"]),
        infoCodes: InfoCodes.fromJson(json["infoCodes"]),
        profile: Profile.fromJson(json["profile"]),
        casePriority: json["casePriority"],
    );

    Map<String, dynamic> toJson() => {
        "localTime": localTime,
        "score": score.toJson(),
        "infoCodes": infoCodes.toJson(),
        "profile": profile.toJson(),
        "casePriority": casePriority,
    };
}

class InfoCodes {
    InfoCodes({
        this.address,
        this.globalVelocity,
        this.velocity,
        this.identityChange,
        this.internet,
    });

    List<String> address;
    List<String> globalVelocity;
    List<String> velocity;
    List<String> identityChange;
    List<String> internet;

    factory InfoCodes.fromJson(Map<String, dynamic> json) => InfoCodes(
        address: List<String>.from(json["address"].map((x) => x)),
        globalVelocity: List<String>.from(json["globalVelocity"].map((x) => x)),
        velocity: List<String>.from(json["velocity"].map((x) => x)),
        identityChange: List<String>.from(json["identityChange"].map((x) => x)),
        internet: List<String>.from(json["internet"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "address": List<dynamic>.from(address.map((x) => x)),
        "globalVelocity": List<dynamic>.from(globalVelocity.map((x) => x)),
        "velocity": List<dynamic>.from(velocity.map((x) => x)),
        "identityChange": List<dynamic>.from(identityChange.map((x) => x)),
        "internet": List<dynamic>.from(internet.map((x) => x)),
    };
}

class Profile {
    Profile({
        this.earlyDecision,
    });

    String earlyDecision;

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        earlyDecision: json["earlyDecision"],
    );

    Map<String, dynamic> toJson() => {
        "earlyDecision": earlyDecision,
    };
}

class Score {
    Score({
        this.result,
        this.factorCodes,
        this.modelUsed,
    });

    String result;
    List<String> factorCodes;
    String modelUsed;

    factory Score.fromJson(Map<String, dynamic> json) => Score(
        result: json["result"],
        factorCodes: List<String>.from(json["factorCodes"].map((x) => x)),
        modelUsed: json["modelUsed"],
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "factorCodes": List<dynamic>.from(factorCodes.map((x) => x)),
        "modelUsed": modelUsed,
    };
}
