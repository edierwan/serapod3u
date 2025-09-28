# Page snapshot

```yaml
- generic [active] [ref=e1]:
  - generic [ref=e3]:
    - heading "Sign in" [level=1] [ref=e4]
    - generic [ref=e5]:
      - textbox "Email" [ref=e6]
      - textbox "Password" [ref=e7]
      - button "Sign in" [ref=e8] [cursor=pointer]
    - generic [ref=e9]:
      - generic [ref=e10]: Fast Login (dev)
      - generic [ref=e11]:
        - button "hq_admin" [ref=e13] [cursor=pointer]
        - button "power_user" [ref=e15] [cursor=pointer]
        - button "manufacturer" [ref=e17] [cursor=pointer]
        - button "warehouse" [ref=e19] [cursor=pointer]
        - button "distributor" [ref=e21] [cursor=pointer]
        - button "shop" [ref=e23] [cursor=pointer]
  - region "Notifications alt+T"
  - button "Open Next.js Dev Tools" [ref=e29] [cursor=pointer]:
    - img [ref=e30] [cursor=pointer]
  - alert [ref=e33]
```