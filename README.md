# Unicorn-Boom-Valuation-Trends-Emerging-Industries-in-Global-Startups-From-2019-2021-
# Global Unicorn Analysis Project

This project analyzes billion-dollar startup companies (unicorns) using a structured SQL and Tableau workflow.

Dataset Source: [DataCamp Datalab – Unicorn Startups Dataset]

## Tools Used
- MySQL (for database creation, staging, and analysis)
- Tableau (for visualization and trend analysis)
- Excel (for preliminary cleaning + supplementary calculations)

## Schema
The dataset is split across 4 tables:
- `companies` — company name, city, country, continent
- `dates` — year founded, date joined unicorn list
- `funding` — valuation, total funding raised
- `industries` — primary industry classification

All tables were joined via `company_id` after staging to form a unified table: `unicorn_master`.

## Key Insights
1. Fintech has the highest total valuation; Internet software has the highest ROI.
2. U.S. leads with 553 unicorns; UK has the highest average valuation ($4.38B).
3. Fastest-to-unicorn industries: Auto, Hardware, and AI.
4. Countries like Bahamas and Colombia rank high in avg. funding per unicorn.
5. Industry growth during COVID: Fintech, Cybersecurity, and E-commerce expanded rapidly.
6. Sequoia Capital appears most frequently among top-valued unicorns.
7. Average time to unicorn status globally is ~6.5 years.
8. Some sectors raise high funding but show low investment returns.
9. Newer unicorns (post-2020) often have lower valuations in certain sectors.
10. Geographic clustering is clear—Fintech thrives in London & New York; AI in Beijing & Palo Alto.

## File Structure
- `/sql_scripts/` — all queries and staging commands
- `/visuals/` — Tableau screenshots and dashboards
- `/summary_insights.md` — text-based findings with commentary

## Usage
Clone the repo, explore SQL scripts, and check Tableau dashboards for deeper insights.

---

*Built for skill growth, not just output.*
