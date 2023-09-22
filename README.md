# Optimal-hedging-strategy-via-FHS-for VaR Calculation

This repository contains the implementation of the Filtered Historical Simulation (FHS) methodology for the calculation of Value-at-Risk (VaR) with a 10-day horizon and a 99% confidence level. The methodology is based on Section 1-2 of the reference [1].

Key Objectives:
i. Application of the FHS methodology to a dataset containing daily quotes (MID) of EUR Interest Rate Swaps (IRS) across various tenors (1y to 10y) spanning the period 1999-2008. The IRS receive a fixed rate at an annual frequency (bond basis) and pay quarterly LIBOR 3m. The implementation follows a similar approach as presented in Section 4 of [1], with a focus on zero-coupon curve bootstrapping based on IRS quotes.

ii. Pricing of a EUR portfolio, analogous to a USD portfolio outlined in Case #1 RM (Slide 5), comprising a 3y x 5y Swaption hedged by a 5y swap with a hedging ratio initially assigned by the Black delta of the swaption. The Black volatility is set at 30%, and the pricing date for the portfolio is December 31st, 2008.

iii. Testing of the swaption's hedging strategy by exploring alternative combinations of IRS instruments with 2y, 5y, and 10y maturities (refer to Slides 7-9 of Case #1 RM) against a yield curve steepener shock identical to the one used in the solution of Case #1 RM.

iv. Determination of the most effective hedging strategy (comprising only IRS with 2y, 5y, or 10y maturity) by minimizing the 10-day VaR with a 99% confidence level, calculated using FHS as of December 31st, 2008. A comparison of this optimal strategy will be made with the strategy discussed in point iii. The Black volatility of the swaption is treated as a non-stochastic parameter in the VaR calculation.

This repository serves as a practical resource for students and practitioners interested in risk management and quantitative finance, offering a hands-on approach to VaR estimation and hedging strategies in a real-world financial context."
