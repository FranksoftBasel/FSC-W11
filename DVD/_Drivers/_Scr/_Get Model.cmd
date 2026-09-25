@echo  off
@echo PC Model
wmic CSProduct get name /format:list
@Pause