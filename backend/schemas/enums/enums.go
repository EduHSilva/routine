package enums

type Frequency string

const (
	Daily          Frequency = "daily"
	MondayToFriday Frequency = "mondayToFriday"
	Weekly         Frequency = "weekly"
	Monthly        Frequency = "monthly"
	Yearly         Frequency = "yearly"
	Unique         Frequency = "unique"
)

type Priority string

const (
	Essential Priority = "essential"
	Normal    Priority = "normal"
	Low       Priority = "low"
)

type MuscleHead string

const (
	HeadLong     MuscleHead = "Long"
	HeadShort    MuscleHead = "Short"
	HeadMiddle   MuscleHead = "Middle"
	HeadSuperior MuscleHead = "Superior"
	HeadInferior MuscleHead = "Inferior"
)

type MuscleFunction string

const (
	Target     MuscleFunction = "Target"
	Synergist  MuscleFunction = "Synergist"
	Stabilizer MuscleFunction = "Stabilizer"
)

type CategoryType string

const (
	Tasks    CategoryType = "tasks"
	Finances CategoryType = "finances"
)

type ItemTag string

const (
	Supermarket ItemTag = "supermarket"
	Drugstore   ItemTag = "drugstore"
	Supplements ItemTag = "supplements"
	Wish        ItemTag = "wish"
)
