# kickoff

## Use Case Diagram:

graph TD
User((User))

    User --> Login[Login / Register]
    User --> ViewFields[View Football Fields]
    User --> SelectDate[Select Date]
    User --> ViewSlots[View Available Slots]
    User --> BookSlot[Book Slot]
    User --> CancelBooking[Cancel Booking]
    User --> BookingHistory[View Booking History]
-------------------------------------------------------------
## Booking Sequence Diagram
sequenceDiagram

    participant U as User
    participant A as Mobile App
    participant C as Cubit
    participant R as Repository
    participant F as Firestore

    U->>A: Select time slot
    A->>C: BookSlot()
    C->>R: requestBooking()
    R->>F: Start Transaction
    F->>F: Check slot availability
    alt Slot Available
        F->>F: Create booking
        F-->>R: Success
        R-->>C: Booking confirmed
        C-->>A: Success state
        A-->>U: Show confirmation
    else Slot Already Booked
        F-->>R: Failure
        R-->>C: Error
        C-->>A: Error state

-------------------------------------------------
## Data Flow Diagram:

flowchart LR:

    UI[Flutter UI]
    Cubit[Booking Cubit]
    Repo[Booking Repository]
    DB[(Firestore Database)]

    UI --> Cubit
    Cubit --> Repo
    Repo --> DB
    DB --> Repo
    Repo --> Cubit
    Cubit --> UI

        A-->>U: Show error message
    end
