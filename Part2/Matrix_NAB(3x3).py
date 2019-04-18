from sympy import *
from sympy import Matrix

# Table of Game Matrix
# |-------------------------------------------------------------------------------------|
# |     |          N          |              A              |             B             |
# |-------------------------------------------------------------------------------------|
# |  N  |     (NN1, NN2)      |          (NA1, NA2)         |        (NB1, NB2)         |
# |-------------------------------------------------------------------------------------|
# |  A  |     (AN1, AN2)      |          (AA1, AA2)         |        (AB1, AB2)         |
# |-------------------------------------------------------------------------------------|
# |  B  |     (BN1, BN2)      |          (BA1, BA2)         |        (BB1, BB2)         |
# |-------------------------------------------------------------------------------------|

# |-------------------------------------------------------------------------------------|
# |     |          N          |              A              |             B             |
# |-------------------------------------------------------------------------------------|
# |  N  |       (0, 0)        |       (-u1, u1-c2-a2)       |  (-u1, u1-c2-a2-d2)       |
# |-------------------------------------------------------------------------------------|
# |  A  |   (u2-c1-a1, -u2)   |  (u2-u1-c1-a1, u1-u2-c2-a2) |  (-u1-c1-a1, u1-c2-a2-d2) |
# |-------------------------------------------------------------------------------------|
# |  B  | (u2-c1-a1-d1, -u2)  |  (u2-c1-a1-d1, -u2-c2-a2)   |  (-c1-a1-d1, -c2-a2-d2)   |
# |-------------------------------------------------------------------------------------|


def NE_calculator(U1, U2, C1, C2, A1, A2, D1, D2):

    # Define: d1 < u1 < c1 + d1, d2 < u2 < c2 + d2, u2 > c1 + a1, u1 > c2 + a2
    u1, u2, c1, c2, a1, a2, d1, d2 = symbols('u1 u2 c1 c2 a1 a2 d1 d2')
    try:
        float(U1)
        float(U2)
        float(C1)
        float(C2)
        float(A1)
        float(A2)
        float(D1)
        float(D2)
        isFloat = true
        if (U1 >= C1 + D1) or (U1 <= D1) or (U2 >= C2 + D2) or (U2 <= D2) or (U2 <= C1 + A1) or (U1 <= C2 + A2):
            print "Invalid Value"
            print "Please follow below rules:"
            print "d1 < u1 < c1 + d1 \nd2 < u2 < c2 + d2 \nu2 > c1 + a1 \nu1 > c2 + a2"
            return
    except TypeError:
        isFloat = false

    u1 = U1
    u2 = U2
    c1 = C1
    c2 = C2
    a1 = A1
    a2 = A2
    d1 = D1
    d2 = D2

    # Actions for P1, E for P2, Pb = 1 - Pn - Pc
    # E(Nop) = NN2 * Pn + AN2 * Pa + BN2 * (1 - Pn - Pa)
    # E(Att) = NA2 * Pn + AA2 * Pa + BA2 * (1 - Pn - Pa)
    # E(Bot) = NB2 * Pn + AB2 * Pa + BB2 * (1 - Pn - Pa)

    # E(Nop) = E(Att) => (NN2 - NA2 - BN2 + BA2) * Pn + (AN2 - AA2 - BN2 + BA2) * Pa = BA2 - BN2
    # E(Nop) = E(Bot) => (NN2 - NB2 - BN2 + BB2) * Pn + (AN2 - AB2 - BN2 + BB2) * Pa = BB2 - BN2
    # E(Att) = E(Bot) => (NA2 - NB2 - BA2 + BB2) * Pn + (AA2 - AB2 - BA2 + BB2) * Pa = BB2 - BA2

    NN2, NA2, NB2, AN2, AA2, AB2, BN2, BA2, BB2 = symbols('NN2 NA2 NB2 AN2 AA2 AB2 BN2 BA2 BB2')

    NN2 = 0
    NA2 = u1 - c2 - a2
    NB2 = u1 - c2 - a2 - d2

    AN2 = - u2
    AA2 = u1 - u2 - c2 - a2
    AB2 = u1 - c2 - a2 - d2

    BN2 = - u2
    BA2 = - u2 - c2 - a2
    BB2 = - c2 - a2 - d2

    # E(Nop) = E(Att), E(Nop) = E(Bot)
    A1 = Matrix([[NN2 - NA2 - BN2 + BA2, AN2 - AA2 - BN2 + BA2], [NN2 - NB2 - BN2 + BB2, AN2 - AB2 - BN2 + BB2]])
    B1 = Matrix([[BA2 - BN2], [BB2 - BN2]])
    res1 = A1.inv() * B1
    if isFloat:
        Pn1 = res1[0, 0]
        Pa1 = res1[1, 0]
        float(Pn1)
        float(Pa1)
        Pb1 = 1 - Pn1 - Pa1
        print "For Player1, mixed Strategy is: "
        print "No-op: " + str(Pn1) + ", Attack: " + str(Pa1) + ", Both: " + str(Pb1) + "\n"
    else:
        print "In symbol calculation for player1, Case1: "
        print "No-op: " + str(res1[0, 0]) + ", Attack: " + str(res1[1, 0]) + "\n"

    # E(Nop) = E(Att), E(Att) = E(Bot)
    A2 = Matrix([[NN2 - NA2 - BN2 + BA2, AN2 - AA2 - BN2 + BA2], [NA2 - NB2 - BA2 + BB2, AA2 - AB2 - BA2 + BB2]])
    B2 = Matrix([[BA2 - BN2], [BB2 - BA2]])
    res2 = A2.inv() * B2
    if not isFloat:
        print "In symbol calculation for player1, Case2: "
        print "No-op: " + str(res2[0, 0]) + ", Attack: " + str(res2[1, 0]) + "\n"

    # E(Nop) = E(Bot), E(Att) = E(Bot)
    A3 = Matrix([[NN2 - NB2 - BN2 + BB2, AN2 - AB2 - BN2 + BB2], [NA2 - NB2 - BA2 + BB2, AA2 - AB2 - BA2 + BB2]])
    B3 = Matrix([[BB2 - BN2], [BB2 - BA2]])
    res3 = A3.inv() * B3
    if not isFloat:
        print "In symbol calculation for player1, Case3: "
        print "No-op: " + str(res3[0, 0]) + ", Attack: " + str(res3[1, 0]) + "\n"

    # Actions for P2, E for P1
    # E(Nop) = NN1 * Pn + NA1 * Pa + NB1 * (1 - Pn - Pa)
    # E(Att) = AN1 * Pn + AA1 * Pa + AB1 * (1 - Pn - Pa)
    # E(Bot) = BN1 * Pn + BA1 * Pa + BB1 * (1 - Pn - Pa)

    # E(Nop) = E(Att) => (NN1 - AN1 - NB1 + AB1) * Pn + (NA1 - AA1 - NB1 + AB1) * Pa = AB1 - NB1
    # E(Nop) = E(Bot) => (NN1 - BN1 - NB1 + BB1) * Pn + (NA1 - BA1 - NB1 + BB1) * Pa = BB1 - NB1
    # E(Att) = E(Bot) => (AN1 - BN1 - AB1 + BB1) * Pn + (AA1 - BA1 - AB1 + BB1) * Pa = BB1 - AB1

    NN1, NA1, NB1, AN1, AA1, AB1, BN1, BA1, BB1 = symbols('NN1 NA1 NB1 AN1 AA1 AB1 BN1 BA1 BB1')

    NN1 = 0
    NA1 = - u1
    NB1 = - u1

    AN1 = u2 - c1 - a1
    AA1 = u2 -u1 -c1 - a1
    AB1 = - u1 - c1 - a1

    BN1 = u2 - c1 - a1 - d1
    BA1 = u2 - c1 - a1 - d1
    BB1 = - c1 - a1 - d1

    # E(Nop) = E(Att), E(Nop) = E(Bot)
    A4 = Matrix([[NN1 - AN1 - NB1 + AB1, NA1 - AA1 - NB1 + AB1], [NN1 - BN1 - NB1 + BB1, NA1 - BA1 - NB1 + BB1]])
    B4 = Matrix([[AB1 - NB1], [BB1 - NB1]])
    res4 = A4.inv() * B4
    if isFloat:
        Pn4 = res4[0, 0]
        Pa4 = res4[1, 0]
        float(Pn4)
        float(Pa4)
        Pb4 = 1 - Pn4 - Pa4
        print "For Player2, mixed Strategy is: "
        print "No-op: " + str(Pn4) + ", Attack: " + str(Pa4) + ", Both: " + str(Pb4) + "\n"
    else:
        print "In symbol calculation for player2, Case1: "
        print "No-op: " + str(res4[0, 0]) + ", Attack: " + str(res4[1, 0]) + "\n"

    # E(Nop) = E(Att), E(Att) = E(Bot)
    A5 = Matrix([[NN1 - AN1 - NB1 + AB1, NA1 - AA1 - NB1 + AB1], [AN1 - BN1 - AB1 + BB1, AA1 - BA1 - AB1 + BB1]])
    B5 = Matrix([[AB1 - NB1], [BB1 - AB1]])
    res5 = A5.inv() * B5
    if not isFloat:
        print "In symbol calculation for player2, Case2: "
        print "No-op: " + str(res5[0, 0]) + ", Attack: " + str(res5[1, 0]) + "\n"

    # E(Nop) = E(Bot), E(Att) = E(Bot)
    A6 = Matrix([[NN1 - BN1 - NB1 + BB1, NA1 - BA1 - NB1 + BB1], [AN1 - BN1 - AB1 + BB1, AA1 - BA1 - AB1 + BB1]])
    B6 = Matrix([[BB1 - NB1], [BB1 - AB1]])
    res6 = A6.inv() * B6
    if not isFloat:
        print "In symbol calculation for player2, Case3: "
        print "No-op: " + str(res6[0, 0]) + ", Attack: " + str(res6[1, 0]) + "\n"

if __name__== "__main__":
    u1, u2, c1, c2, a1, a2, d1, d2 = symbols('u1 u2 c1 c2 a1 a2 d1 d2')
    # Calculation with symbol
    # NE_calculator(u1, u2, c1, c2, a1, a2, d1, d2)

    # Calculation with value
    NE_calculator(1100, 1000, 750, 800, 125, 100, 400, 500)