warning('off', 'all')
file_path = 'C:\Users\230Student03\Desktop\auto_sorting';
file_names = {dir(file_path).name};
raw_data_file_name = file_names(contains(file_names,"Dataset_","IgnoreCase",true));
raw_data_file_name = raw_data_file_name{1};
old_T = readtable(append(file_path,'\',raw_data_file_name));
first = true;
while true 
    file_names = {dir(file_path).name};
    raw_data_file_name = file_names(contains(file_names,"Dataset_","IgnoreCase",true));
    raw_data_file_name = raw_data_file_name{1};
    current_T = readtable(append(file_path,'\',raw_data_file_name));
    if height(old_T) < height(current_T) || first == true
        copy_T = old_T;
        old_T = current_T;
        if first == false
            copy_T.id = string(copy_T.id);
            current_T.id = string(current_T.id);
            current_T(matches(current_T.id,copy_T.id),:) = [];
        else
            first = false;
        end
        [FTT,RST,OSPAN,WPA_train,WPA_morning,EMA_morning,EMA_evening,PSS,forget_evening,forget_morning,VGE,GAD_7,CES_D,PDS,PSPQ,ASWS,ISO,ISC,SRCF,CSB,CASS,EMA,SMQ,UK_1,UK_2,UK_3,UK_4,UK_5,UK_6] = sorting(current_T);
        
        new_FTT = update_FTT(FTT);
        new_RST = update_RST(RST);
        new_WPA_train = update_WPA_night(WPA_train);
        questionnaires = {EMA_morning,EMA_evening,PSS,forget_evening,forget_morning,VGE,GAD_7,CES_D,PDS,PSPQ,ASWS,ISO,ISC,SRCF,CSB,CASS,EMA,SMQ,UK_1,UK_2,UK_3,UK_4,UK_5,UK_6};
        exporting(questionnaires,file_path);

    end
end
%%
function [T_1,T_2,T_3,T_4,T_5,T_6,T_7,T_8,T_9,T_10,T_11,T_12,T_13,T_14,T_15,T_16,T_17,T_18,T_19,T_20,T_21,T_22,T_23,T_24,T_25,T_26,T_27,T_28,T_29] = sorting(current_T)
format long g
user_long = current_T.user;
for i = 1:length(user_long)
    c = char(user_long{i});
    user_long{i} = c(end-2:end);
end
current_T.user = user_long;
current_T.user = string(current_T.user);
tables = table;
user = unique(current_T.user);
FTT = table;
RST = table;
OSPAN = table;
WPA_train = table;
WPA_morning = table;
EMA_morning = table;
EMA_evening = table;
PSS = table;
forget_evening = table;
forget_morning = table;
VGE = table;
GAD_7 = table;
CES_D = table;
PDS = table;
PSPQ = table;
ASWS = table;
ISO = table;
ISC = table;
SRCF = table;
CSB = table;
CASS =table; 
EMA = table;
SMQ = table;
UK_1 = table;
UK_2 = table;
UK_3 = table;
UK_4 = table;
UK_5 = table;
UK_6 = table;
for i = 1:height(current_T)
    assigned = false;
    json = current_T{i,'data'}{1};
    struct = jsondecode(json);
    struct_data = struct.data;
    struct_meta = struct.metadata;
    row_data = struct2table(struct_data,"AsArray", true);
    row_meta = struct2table(struct_meta,"AsArray",true);
    row_meta(:,'page_advances') = [];
    row = horzcat(current_T(i,"user"), row_data, row_meta);
    col_names = row.Properties.VariableNames;
    if sum(contains(col_names,"finger_tap")) >= 1
        FTT = vertcat(FTT,row);
        assigned = true;
    elseif sum(contains(col_names,"rst")) == 1 && width(row) == 4
        RST = vertcat(RST,row);
        assigned = true;
    elseif sum(contains(col_names,"ospan")) >= 1
        OSPAN = vertcat(OSPAN,row);
        assigned = true;
    elseif sum(contains(col_names,"wpa_training")) >= 1
        WPA_train = vertcat(WPA_train,row);
        assigned = true;
    elseif sum(contains(col_names,"wpa_morning_testing")) >= 1
        WPA_morning = vertcat(WPA_morning,row);
        assigned = true;
    elseif sum(contains(col_names,"where_EMA_morning")) >= 1
        EMA_morning = update_q(EMA_morning,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"where_EMA_evening")) >= 1
        EMA_evening = update_q(EMA_evening,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"upset_something_unexpected")) >= 1
        PSS = vertcat(PSS,row);
        assigned = true;
    elseif sum(contains(col_names,"caffeinated_beverages")) >= 1
        forget_evening = update_q(forget_evening,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"get_out_of_bed")) >= 1
        forget_morning = update_q(forget_morning,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"regularly_plays_games")) >= 1
        VGE = update_q(VGE,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"nervous_anxious_onedge")) >= 1
        GAD_7 = update_q(GAD_7,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"more_bother")) >= 1
        CES_D = update_q(CES_D,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"height_growth")) >= 1
        PDS = update_q(PDS,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"time_asleep_weekday")) >= 1
        PSPQ = update_q(PSPQ,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"want_stay_up")) >= 1
        ASWS = update_q(ASWS,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"Self_scale_mom")) >= 1
        ISO = update_q(ISO,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"Self_scale_child")) >= 1
        ISC = update_q(ISC,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"rules_sleep")) >= 1
        SRCF = update_q(SRCF,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"weeknights_time")) >= 1
        CSB = update_q(CSB,row,col_names);
        assigned = true;
    elseif sum(contains(col_names,"parent_proud")) >= 1
        CASS = update_q(CASS,row,col_names); 
        assigned = true;
    elseif sum(matches(col_names,"where_EMA"))>=1
        EMA = update_q(EMA,row,col_names);
        assigned = true;
    elseif sum(matches(col_names,"social_media_usage"))>=1
        SMQ = update_q(SMQ,row,col_names);
        assigned = true;
    elseif sum(matches(col_names,"filling_out_diary"))>=1
        UK_1 = update_q(UK_1,row,col_names);
        assigned = true;
    elseif sum(matches(col_names,"different_friends"))>=1
        UK_2 = update_q(UK_2,row,col_names);
        assigned = true;
    elseif sum(matches(col_names,"good_job_caregivermom"))>=1
        UK_3 = update_q(UK_3,row,col_names);
        assigned = true;
    elseif sum(matches(col_names,"sure_parent"))>=1
        UK_4 = update_q(UK_4,row,col_names);
        assigned = true;
    elseif sum(matches(col_names,"financial_debt"))>=1
        UK_5 = update_q(UK_5,row,col_names);
        assigned = true;
    elseif sum(matches(col_names,"child_good_job"))>=1
        UK_6 = update_q(UK_6,row,col_names);
        assigned = true;
    end
    if i == height(current_T)
        disp("done sorting")
        %output
        T_1 = FTT;
        T_2 = RST;
        T_3 = OSPAN;
        T_4 = WPA_train;
        T_5 = WPA_morning;
        T_6 = EMA_morning;
        T_7 = EMA_evening;
        T_8 = PSS;
        T_9 = forget_evening;
        T_10 = forget_morning;
        T_11 = VGE;
        T_12 = GAD_7;
        T_13 = CES_D;
        T_14 = PDS;
        T_15 = PSPQ;
        T_16 = ASWS;
        T_17 = ISO;
        T_18 = ISC;
        T_19 = SRCF;
        T_20 = CSB;
        T_21 = CASS; 
        T_22 = EMA;
        T_23 = SMQ;
        T_24 = UK_1;
        T_25 = UK_2;
        T_26 = UK_3;
        T_27 = UK_4;
        T_28 = UK_5;
        T_29 = UK_6;
    end
    if assigned == false
        disp("unknown data")
        break;
    end

end
end
%%
function y = exporting(cell,file_path)
names = ["EMA_morning","EMA_evening","PSS","forget_evening","forget_morning","VGE","GAD_7","CES_D","PDS","PSPQ","ASWS","ISO","ISC","SRCF","CSB","CASS","EMA","SMQ","UK_1","UK_2","UK_3","UK_4","UK_5","UK_6"];
for i = 1:width(cell)
    writetable(cell{i},append(file_path,'\output\',names(i),".csv"));
end
y = "done exproting";
end
%%
function y = update_RST(RST)
new = table;
for i = 1:height(RST)
    A = RST{i,'rst'}{1};
    for j = 1:height(A)
        B = A{j,1};
        task = table;
        for k = 2:height(B)
            row = struct2table(B{k,1},"AsArray",true);
            task = vertcat(task,row);
        end
        dup = repelem(RST(i,:),height(B)-1,1);
        dup = horzcat(dup,task);
        new = vertcat(new,dup);
    end
end
new(:, 'rst') = [];
y = new;
end
%%
function y = update_WPA_night(WPA_train)
new = table;
for i = 1:height(WPA_train)
    A = struct2table(WPA_train.wpa_night_testing{i,1});
    pairs = WPA_train{i,"wpa_training"}.pairs;
    w_pairs = {char(pairs{1})}.';
    for j = 2:height(pairs)
        w_pairs(end + 1) = {char(pairs{j})}.';
    end
    w_pairs = jsonencode(w_pairs);
    dup = repelem(horzcat(WPA_train(i,:),{w_pairs}),height(A),1);
    for j = 1:height(A)
        A{j,'wordpair'} = [string(A{j,'wordPair'}{1}{1}),string(A{j,'wordPair'}{1}{2})];
    end
    A(:,'wordPair') = [];
    columns = A.Properties.VariableNames;
    columns([1:2 3:end]) = columns([end-1:end 1:end-2]);
    A = A(:,columns);
    dup = horzcat(dup,A);
    new = vertcat(new,dup);
end
new(:,'wpa_night_testing') = [];
new(:,'wpa_training') = [];
new = renamevars(new,"Var7","wpa_training");
WPA_train_pre= new;
WPA_train_pre.date = datetime(WPA_train_pre.started_at /1000,"ConvertFrom","posixtime","Format","uuuu-MM-dd","TimeZone","America/Los_Angeles");
y = WPA_train_pre;
end

%%

new = table;
for i = 1:height(WPA_morning)
    A = struct2table(WPA_morning.wpa_morning_testing{i,1});
    dup = repelem(WPA_morning(i,:),height(A),1);
    for j = 1:height(A)
        A{j,'wordpair'} = [string(A{j,'wordPair'}{1}{1}),string(A{j,'wordPair'}{1}{2})];
    end
    A(:,'wordPair') = [];
    columns = A.Properties.VariableNames;
    columns([1:2 3:end]) = columns([end-1:end 1:end-2]);
    A = A(:,columns);
    dup = horzcat(dup,A);
    new = vertcat(new,dup);
end
new(:,'wpa_morning_testing') = [];
WPA_morning = new;
WPA_morning.date = datetime(WPA_morning.started_at /1000,"ConvertFrom","posixtime","Format","dd-MMM-uuuu","TimeZone","America/Los_Angeles");

%%
%OSPAN
pre_prosess = table;
for i = 1:height(OSPAN)
    pre = table;
    for j = 1:3
        task = append("ospan_",string(j));
        A = OSPAN{i,task}{1};
        for k = 1:height(A)
            struct = A{k};
            for l = 1:height(struct)-1
                test = struct2table(struct{l},"AsArray",true);
                if width(test) <= 4
                    test = test_sub;
                    continue
                end
                copy = struct2table(test{1,"equation"},"AsArray",true);
                eq = append(string(copy{1,"a"}),' ',char(copy{1,"operator"}),' ',string(copy{1,"b"}),' = ',string(copy{1,"result"}));
                eq = char(eq);
                test.equation = [];
                test{1,"equation"} = {eq};
                test.letter = {test{1,"letter"}};
                if test{1,"correctAnswer"} == 1
                    test{1,"user_is_correct"} = {'True'};
                else
                    test{1,"user_is_correct"} = {'False'};
                end
                
                test.math_correct = copy.isCorrect;

                if test{1,"missed"} == 1
                    test{1,"choice_0"} = {'missed'};
                elseif test{1,"choice"} == 1 
                    test{1,"choice_0"} = {'True'};
                else
                    test{1,"choice_0"} = {'False'};
                end

                if string(test{1,"choice_0"}{1}) == "True" || string(test{1,"choice_0"}{1}) == "False"
                    test(:,["correctAnswer","choice","missed"]) = [];
                    test = renamevars(test,["choice_0", "decisionTime","startTime"],["choice","user_input_time","user_start_time"]);
                else
                    test(:,["correctAnswer","missed"]) = [];
                    test = renamevars(test,["choice_0","startTime"],["choice","user_start_time"]);
                    test{1,"user_input_time"} = nan;
                end

                test{1,"problem_set"} = {char(task)};
                test{1,"user_letters"} = {''};
                test{1,"letters"} = {''};
                test_sub = test;
                pre = vertcat(pre,test);
            end
            test_0 = struct2table(struct{end},"AsArray",true);
            test_0 = renamevars(test_0,["input", "inputTime","startTime"], ["user_letters","user_input_time","user_start_time"]);
            test(:,["user_input_time","user_start_time","user_letters","letters"]) = [];
            bottom = horzcat(test_0,test);
            bottom{1,"letter"} = {' '};
            bottom{1,"equation"} = {''};
            bottom{1,"math_correct"} = 0;
            bottom{1,"user_is_correct"} = {''};
            bottom{1,"choice"} = {''};
            bottom.user_letters = {bottom{1,"user_letters"} };
            bottom.letters = {bottom{1,"letters"}};
            pre = vertcat(pre,bottom);
        end
    end
    pre = horzcat(repelem(OSPAN(i,["user","started_at","finished_at"]),height(pre),1),pre);
    pre_prosess = vertcat(pre_prosess,pre);

end
col_names = pre_prosess.Properties.VariableNames;
col_names([4:5 6:end]) = col_names([end-1:end 4:end-2]);
col_names([6:7 8]) = col_names([7:8 6]);
pre_prosess(:,col_names)

%%
function y = update_FTT(FTT)
new_FTT = table;
for i = 1:height(FTT)
    finger = struct2table(FTT.finger_tap{i});
    rep = horzcat(repelem(FTT(i,["user","started_at","finished_at","test_type"]),height(finger),1),finger);
    new_FTT = vertcat(new_FTT,rep);
end
new_FTT.date = datetime(new_FTT.startTime/1000,"ConvertFrom","posixtime","Format","MM/dd/uuuu HH:mm:ss","TimeZone","America/Los_Angeles");
for i = 1:height(new_FTT)
    input = string(new_FTT.input{i});
    target = string(new_FTT.target{i});
    strokes = new_FTT.strokes{i};
    result = split(input, target);
    [score,error,time] = scoring_FTT(result,target,strokes);
    new_FTT{i,"score"} = score;
    new_FTT{i,"error"} = error;
    new_FTT{i,"test_trial"} = {time};
    if score ~= 0 
        new_FTT{i,"fastest_time"} = min(time);
        new_FTT{i,"slowest_time"} = max(time);
        new_FTT{i,"ave_time"} = mean(time);
        new_FTT{i,"std_time"} = std(time);
    end
end
y = new_FTT;
end

function [x, y, z] = scoring_FTT(result,target,strokes)
correct = 0;
a = 1;
consec = false;
reaction_time = [];
first = false;
consec_error = false;
error = 0;
for i = 1:length(result)
    if isempty(char(result(i))) == 1 
        if a+length(char(target))-1 <= length(strokes)
            correct = correct + 1;
            time = strokes(a+length(char(target))-1) - strokes(a);
            time = datetime(time/1000,"ConvertFrom","posixtime","Format","uuuu-MM-dd'T'HH:mm:ss.SSSSSS");
            time = second(time);
            time = datenum(time) * 1000;
            reaction_time(end + 1) = time;
            a = a + length(char(target));
            if i == 1
                first = true;
            elseif first == false && i ~= 1
                consec = true;
                consec_error = false;
            end
        end
    else
        if consec == true && first == false || consec_error == true
            correct = correct + 1;
            time = strokes(a + length(char(target))-1) - strokes(a);
            time = datetime(time/1000,"ConvertFrom","posixtime","Format","uuuu-MM-dd'T'HH:mm:ss.SSSSSS");
            time = second(time);
            time = datenum(time) * 1000;
            reaction_time(end + 1) = time;
            a = a + length(char(target));
        end
        a = a + length(char(result(i)));
        error = error + length(char(result(i)));
        consec = false;
        consec_error = true;
        first = false;
    end
end
x = correct;
y = error;
z = reaction_time;
end




function T = update_q(EMA_evening,row,col_names)
if width(EMA_evening) == 0
    EMA_evening = row;
elseif sum(length(setdiff(col_names,EMA_evening.Properties.VariableNames))) > 0 || sum(length(setdiff(EMA_evening.Properties.VariableNames,col_names))) > 0
    if sum(length(setdiff(col_names,EMA_evening.Properties.VariableNames))) > 0
        miss_cols = setdiff(col_names,EMA_evening.Properties.VariableNames);
        match_cols = matches(col_names,EMA_evening.Properties.VariableNames);
        match_cols = EMA_evening(1,col_names(match_cols)).Properties.VariableNames;
        %EMA_morning = vertcat(EMA_morning,row(1,match_cols));
        EMA_evening(end+1,:)  = EMA_evening(end,:);
        EMA_evening(end,match_cols) = row(1,match_cols);
        for j = 1:length(miss_cols)
            EMA_evening{end,miss_cols{j}} = row{1,miss_cols{j}};
        end
    else
        miss_cols = setdiff(EMA_evening.Properties.VariableNames,col_names);
        match_cols = matches(col_names,EMA_evening.Properties.VariableNames);
        match_cols = EMA_evening(1,col_names(match_cols)).Properties.VariableNames;
        EMA_evening(end+1,:)  = EMA_evening(end,:);
        EMA_evening(end,match_cols) = row(1,match_cols);
        for j = 1:length(miss_cols)
            if class(EMA_evening{end,miss_cols{j}}) == "cell"
                EMA_evening{end,miss_cols{j}}{1} = {};
            elseif class(EMA_evening{end,miss_cols{j}}) == "string"
                EMA_evening{end,miss_cols{j}} = string(missing);
            elseif class(EMA_evening{end,miss_cols{j}}) == "double"
                EMA_evening{end,miss_cols{j}} = nan;
            end
        end
    end
else
    EMA_evening = vertcat(EMA_evening,row);
end
T = EMA_evening;
end